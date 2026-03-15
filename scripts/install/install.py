#!/usr/bin/env python3
"""
Interactive installer for Greg's Dotfiles
Detects OS and lets user choose which tools to configure
"""

import argparse
import os
import sys
import subprocess
from pathlib import Path
from typing import List, Dict, Set, Optional

# Try to import curses for TUI mode
try:
	import curses
	HAS_CURSES = True
except ImportError:
	HAS_CURSES = False

# Parse command-line arguments
def parse_args():
	parser = argparse.ArgumentParser(
		description='Interactive installer for Greg\'s Dotfiles',
		formatter_class=argparse.RawDescriptionHelpFormatter,
		epilog='''
Examples:
  %(prog)s --profile minimal           Install minimal profile
  %(prog)s --tools zsh,neovim,git       Install specific tools
  %(prog)s --categories shells,editors Install entire categories
  %(prog)s --profile developer --yes    Non-interactive installation
  %(prog)s --dry-run                    Show what would be installed

Profiles:
  minimal         Essential tools for everyday use (4 tools)
  developer       Full development environment (~20 tools)
  terminal-ninja  Terminal productivity focus (~25 tools)
  sysadmin        Server management tools (~15 tools)
  full            All available tools

For more information, see the README.
		'''
	)

	parser.add_argument(
		'--profile', '-p',
		choices=['minimal', 'developer', 'terminal-ninja', 'sysadmin', 'full'],
		help='Select installation profile'
	)

	parser.add_argument(
		'--tools', '-t',
		help='Comma-separated list of tools to install (e.g., zsh,neovim,git)'
	)

	parser.add_argument(
		'--categories', '-c',
		help='Comma-separated list of categories to install (e.g., shells,editors)'
	)

	parser.add_argument(
		'--yes', '-y',
		action='store_true',
		help='Auto-accept all prompts (non-interactive mode)'
	)

	parser.add_argument(
		'--dry-run',
		action='store_true',
		help='Show what would be installed without actually installing'
	)

	parser.add_argument(
		'--tui',
		action='store_true',
		help='Use terminal UI with mouse support'
	)

	parser.add_argument(
		'--skip-python-check',
		action='store_true',
		help=argparse.SUPPRESS  # For internal use by bootstrap script
	)

	return parser.parse_args()

# ANSI color codes
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    BOLD = '\033[1m'
    NC = '\033[0m'  # No Color

# Predefined profiles
PROFILES = {
    'minimal': {
        'name': 'Minimal',
        'description': 'Essential tools for everyday use',
        'tools': {
            'shells': ['zsh'],
            'navigation': ['fd', 'ripgrep', 'fzf'],
            'version-control': ['git'],
            'documentation': ['tldr'],
        }
    },
    'developer': {
        'name': 'Developer',
        'description': 'Full development environment',
        'tools': {
            'shells': ['zsh'],
            'navigation': ['yazi', 'fd', 'ripgrep', 'fzf'],
            'editors': ['neovim'],
            'version-control': ['git', 'gh', 'lazygit'],
            'development': ['python', 'rust', 'nodejs'],
            'containers': ['docker', 'version-managers'],
            'documentation': ['tldr', 'tealdeer'],
            'monitoring': ['btop'],
            'transfer': ['aria2'],
            'security': ['ssh'],
        }
    },
    'full': {
        'name': 'Full Setup',
        'description': 'All available tools',
        'tools': 'all'  # Special marker for all tools
    },
    'terminal-ninja': {
        'name': 'Terminal Ninja',
        'description': 'Focus on terminal productivity',
        'tools': {
            'terminals': ['zellij', 'tmux'],
            'shells': ['zsh', 'fish'],
            'navigation': ['yazi', 'fd', 'ripgrep', 'fzf'],
            'version-control': ['git', 'lazygit', 'git-fuzzy'],
            'monitoring': ['btop', 'glances'],
            'network': ['gping', 'httpie', 'bandwhich'],
            'productivity': ['todotxt', 'terminal-notes'],
            'transfer': ['aria2', 'wget2'],
            'documentation': ['tldr', 'tealdeer', 'cheat'],
            'security': ['age', 'ssh', 'totp'],
            'fun': ['fetch', 'utilities', 'qalc'],
        }
    },
    'sysadmin': {
        'name': 'System Administrator',
        'description': 'Server and system management tools',
        'tools': {
            'shells': ['zsh'],
            'navigation': ['fd', 'ripgrep', 'fzf'],
            'monitoring': ['btop', 'glances'],
            'version-control': ['git'],
            'network': ['gping', 'bandwhich'],
            'transfer': ['aria2', 'curlie'],
            'containers': ['docker', 'kubernetes'],
            'security': ['ssh', 'age'],
            'archive': ['compressors', 'parallel', 'unar'],
            'documentation': ['tldr', 'man'],
        }
    },
}

# Tool categories
CATEGORIES = {
    'terminals': {
        'description': 'Terminal Multiplexers',
        'tools': ['zellij', 'tmux', 'screen']
    },
    'editors': {
        'description': 'Text Editors',
        'tools': ['neovim', 'helix', 'emacs']
    },
    'shells': {
        'description': 'Shell Configurations',
        'tools': ['zsh', 'fish', 'nushell']
    },
    'navigation': {
        'description': 'File Navigation',
        'tools': ['yazi', 'fd', 'ripgrep', 'fzf']
    },
    'monitoring': {
        'description': 'System Monitoring',
        'tools': ['btop', 'glances', 'modern-utils']
    },
    'version-control': {
        'description': 'Version Control',
        'tools': ['git', 'gh', 'lazygit', 'git-fuzzy']
    },
    'network': {
        'description': 'Network Tools',
        'tools': ['gping', 'httpie', 'speedtest', 'bandwhich']
    },
    'productivity': {
        'description': 'Productivity Tools',
        'tools': ['presenterm', 'todotxt', 'jira-cli', 'terminal-notes']
    },
    'transfer': {
        'description': 'Download/Transfer',
        'tools': ['aria2', 'curlie', 'wget2']
    },
    'development': {
        'description': 'Dev Tools',
        'tools': ['python', 'rust', 'nodejs', 'project-templates']
    },
    'containers': {
        'description': 'Container Tools',
        'tools': ['nix', 'docker', 'kubernetes', 'version-managers']
    },
    'security': {
        'description': 'Security Tools',
        'tools': ['age', 'ssh', '1password-cli', 'totp']
    },
    'archive': {
        'description': 'Archive Tools',
        'tools': ['compressors', 'parallel', 'unar', 'image-tools']
    },
    'documentation': {
        'description': 'Documentation',
        'tools': ['tldr', 'tealdeer', 'man', 'cheat', 'docuum']
    },
    'fun': {
        'description': 'Fun Utilities',
        'tools': ['fetch', 'utilities', 'qalc']
    }
}

def detect_os() -> str:
    """Detect the current operating system."""
    if sys.platform == 'darwin':
        return 'macos'

    # Try to read from /etc/os-release
    os_release = Path('/etc/os-release')
    if os_release.exists():
        with open(os_release) as f:
            content = f.read()
            if 'ID=fedora' in content:
                return 'fedora'
            elif 'ID=ubuntu' in content:
                return 'ubuntu'
            elif 'ID=arch' in content:
                return 'arch'
            elif 'ID=gentoo' in content:
                return 'gentoo'
            elif 'ID=void' in content:
                return 'void'
            elif 'ID=oracle' in content:
                return 'oracle'
            elif 'ID=rocky' in content:
                return 'rocky'
            elif 'ID=alpine' in content:
                return 'alpine'
            elif 'ID=debian' in content or 'ID=raspbian' in content:
                # Check if Raspberry Pi
                if Path('/proc/cpuinfo').exists():
                    with open('/proc/cpuinfo') as f:
                        if 'Raspberry Pi' in f.read() or 'BCM' in f.read():
                            return 'rpi'
                return 'ubuntu'  # Debian-based, use Ubuntu config
            elif 'ID=rhel' in content or 'ID=centos' in content:
                return 'rocky'  # RHEL-compatible

    # Fallback: check specific release files
    release_files = {
        '/etc/fedora-release': 'fedora',
        '/etc/arch-release': 'arch',
        '/etc/gentoo-release': 'gentoo',
        '/etc/ubuntu-release': 'ubuntu',
        '/etc/void-release': 'void',
        '/etc/oracle-release': 'oracle',
        '/etc/rocky-release': 'rocky',
        '/etc/alpine-release': 'alpine',
        '/etc/redhat-release': 'rocky',
        '/etc/debian_version': 'rpi' if is_raspberry_pi() else 'ubuntu'
    }

    for release_file, os_name in release_files.items():
        if Path(release_file).exists():
            return os_name

    # Check for FreeBSD
    if sys.platform == 'freebsd':
        return 'freebsd'

    # Check for WSL
    if Path('/proc/version').exists():
        with open('/proc/version') as f:
            if 'microsoft' in f.read().lower():
                return 'windows'

    return 'unknown'

def is_raspberry_pi() -> bool:
    """Check if running on Raspberry Pi."""
    cpuinfo = Path('/proc/cpuinfo')
    if cpuinfo.exists():
        with open(cpuinfo) as f:
            content = f.read()
            return 'Raspberry Pi' in content or 'BCM' in content
    return False

def clear_screen():
    """Clear the terminal screen."""
    os.system('clear' if os.name != 'nt' else 'cls')

def print_header():
    """Print the installer header."""
    clear_screen()

    print(f"{Colors.CYAN}╔════════════════════════════════════════════════════════════╗{Colors.NC}")
    print(f"{Colors.CYAN}║{Colors.NC}        {Colors.GREEN}Greg's Dotfiles - Interactive Installer{Colors.NC}           {Colors.CYAN}║{Colors.NC}")
    print(f"{Colors.CYAN}╚════════════════════════════════════════════════════════════╝{Colors.NC}")
    print()

def print_system_info(current_os: str):
    """Print system information."""
    print(f"{Colors.BLUE}System Information:{Colors.NC}")
    print(f"  OS:        {Colors.GREEN}{current_os.capitalize()}{Colors.NC}")
    print(f"  Hostname:  {Colors.GREEN}{os.uname().nodename}{Colors.NC}")
    print(f"  User:      {Colors.GREEN}{os.getenv('USER', 'unknown')}{Colors.NC}")
    print()

def welcome(current_os: str):
    """Display welcome message."""
    print_header()
    print_system_info(current_os)

    print(f"{Colors.GREEN}Welcome to the interactive dotfiles installer!{Colors.NC}")
    print()
    print("This installer will help you:")
    print("  • Select a profile or customize your tool selection")
    print("  • Choose specific tools within categories")
    print("  • Install tools (optional)")
    print("  • Apply OS-specific configuration layers")
    print("  • Create symlinks to your home directory")
    print()

    try:
        input(f"{Colors.YELLOW}Press Enter to continue...{Colors.NC}")
    except (EOFError, KeyboardInterrupt):
        print()

def select_profile() -> Optional[str]:
    """Let user select a profile or choose custom."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Step 1: Select Installation Profile{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    print("Choose a profile to get started, or select custom to pick specific tools:\n")

    # Display profiles
    profile_list = list(PROFILES.keys())
    for i, (key, profile) in enumerate(PROFILES.items(), 1):
        name = profile['name']
        desc = profile['description']
        print(f"  {Colors.CYAN}{i}){Colors.NC} {Colors.BOLD}{name}{Colors.NC} - {desc}")
    print(f"  {Colors.CYAN}{len(profile_list) + 1}){Colors.NC} {Colors.BOLD}Custom{Colors.NC} - Choose specific tools manually\n")

    while True:
        try:
            selection = input(f"{Colors.YELLOW}→ Select profile [1-{len(profile_list) + 1}]: {Colors.NC}").strip()

            if not selection:
                selection = "1"  # Default to minimal

            idx = int(selection) - 1

            if idx == len(profile_list):
                # Custom selection
                return None
            elif 0 <= idx < len(profile_list):
                return profile_list[idx]
            else:
                print(f"{Colors.RED}Invalid selection. Please enter a number between 1 and {len(profile_list) + 1}.{Colors.NC}")

        except ValueError:
            print(f"{Colors.RED}Invalid input. Please enter a number.{Colors.NC}")
        except (EOFError, KeyboardInterrupt):
            print(f"\n{Colors.RED}Installation cancelled.{Colors.NC}")
            sys.exit(0)

def get_tools_from_profile(profile_key: str) -> Set[str]:
    """Get set of tools from a profile."""
    profile = PROFILES[profile_key]

    if profile['tools'] == 'all':
        # Return all tools from all categories
        all_tools = set()
        for category in CATEGORIES.values():
            all_tools.update(category['tools'])
        return all_tools

    # Return tools specified in profile
    selected_tools = set()
    for category, tools in profile['tools'].items():
        selected_tools.update(tools)
    return selected_tools

def select_categories(tools_from_profile: Optional[Set[str]] = None) -> Set[str]:
    """Let user select categories and individual tools."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Step 2: Select Tools{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    if tools_from_profile:
        print(f"Pre-selected tools from profile:\n")
        for tool in sorted(tools_from_profile):
            print(f"  {Colors.GREEN}✓{Colors.NC} {tool}")
        print()

        print("You can:")
        print(f"  {Colors.CYAN}1){Colors.NC} Accept these tools as-is")
        print(f"  {Colors.CYAN}2){Colors.NC} Customize tool selection")
        print()

        while True:
            try:
                choice = input(f"{Colors.YELLOW}→ Choice [1/2]: {Colors.NC}").strip()

                if not choice or choice == "1":
                    # Accept profile as-is
                    return tools_from_profile
                elif choice == "2":
                    # Customize
                    break
                else:
                    print(f"{Colors.RED}Please enter 1 or 2.{Colors.NC}")
            except (EOFError, KeyboardInterrupt):
                print(f"\n{Colors.RED}Installation cancelled.{Colors.NC}")
                sys.exit(0)

    # Build selection map
    selected_tools = tools_from_profile or set()

    while True:
        print("\n" + f"{Colors.BOLD}Select tools by category:{Colors.NC}\n")

        # Display categories with selection status
        category_list = list(CATEGORIES.keys())
        for i, cat in enumerate(category_list, 1):
            desc = CATEGORIES[cat]['description']
            tools = CATEGORIES[cat]['tools']
            selected = sum(1 for t in tools if t in selected_tools)
            total = len(tools)

            if selected == total:
                status = f"{Colors.GREEN}[All]{Colors.NC}"
            elif selected > 0:
                status = f"{Colors.YELLOW}[{selected}/{total}]{Colors.NC}"
            else:
                status = f"{Colors.CYAN}[None]{Colors.NC}"

            print(f"  {Colors.CYAN}{i}){Colors.NC} {desc} {status}")

        print(f"\n  {Colors.CYAN}a){Colors.NC} Accept current selection")
        print(f"  {Colors.CYAN}q){Colors.NC} Quit installer\n")

        choice = input(f"{Colors.YELLOW}→ Select category to edit [1-{len(category_list)}/a/q]: {Colors.NC}").strip().lower()

        if choice == 'q':
            print(f"\n{Colors.RED}Installation cancelled.{Colors.NC}")
            sys.exit(0)
        elif choice == 'a':
            if selected_tools:
                return selected_tools
            else:
                print(f"{Colors.RED}You must select at least one tool.{Colors.NC}")
        elif choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(category_list):
                category = category_list[idx]
                selected_tools = edit_category_tools(category, selected_tools)
            else:
                print(f"{Colors.RED}Invalid category number.{Colors.NC}")

def edit_category_tools(category: str, current_selection: Set[str]) -> Set[str]:
    """Edit tool selection within a category."""
    tools = CATEGORIES[category]['tools']
    desc = CATEGORIES[category]['description']

    while True:
        print(f"\n{Colors.BOLD}{desc}{Colors.NC}\n")

        # Display tools with current selection
        for i, tool in enumerate(tools, 1):
            if tool in current_selection:
                status = f"{Colors.GREEN}[✓]{Colors.NC}"
            else:
                status = f"{Colors.CYAN}[ ]{Colors.NC}"
            print(f"  {Colors.CYAN}{i}){Colors.NC} {status} {tool}")

        print(f"\n  {Colors.CYAN}a){Colors.NC} Select all")
        print(f"  {Colors.CYAN}n){Colors.NC} Select none")
        print(f"  {Colors.CYAN}d){Colors.NC} Done\n")

        choice = input(f"{Colors.YELLOW}→ Toggle tool [1-{len(tools)}/a/n/d]: {Colors.NC}").strip().lower()

        if choice == 'd':
            return current_selection
        elif choice == 'a':
            current_selection.update(tools)
        elif choice == 'n':
            current_selection.difference_update(tools)
        elif choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(tools):
                tool = tools[idx]
                if tool in current_selection:
                    current_selection.remove(tool)
                else:
                    current_selection.add(tool)
            else:
                print(f"{Colors.RED}Invalid tool number.{Colors.NC}")

def confirm_install(selected_tools: Set[str], current_os: str) -> bool:
    """Confirm installation with user."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Step 3: Confirm Installation{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    # Group tools by category
    tools_by_category = {}
    for tool in selected_tools:
        for category, data in CATEGORIES.items():
            if tool in data['tools']:
                if category not in tools_by_category:
                    tools_by_category[category] = []
                tools_by_category[category].append(tool)
                break

    print(f"{Colors.BOLD}Summary of selections:{Colors.NC}\n")
    print(f"  Total tools: {Colors.GREEN}{len(selected_tools)}{Colors.NC}\n")

    for category in sorted(tools_by_category.keys()):
        cat_desc = CATEGORIES[category]['description']
        tools = sorted(tools_by_category[category])
        print(f"{Colors.CYAN}{cat_desc}:{Colors.NC}")
        for tool in tools:
            print(f"  • {tool}")
        print()

    print(f"{Colors.YELLOW}Target OS: {Colors.GREEN}{current_os.capitalize()}{Colors.NC}\n")

    while True:
        try:
            response = input(f"{Colors.YELLOW}→ Proceed with installation? [y/N]: {Colors.NC}").strip().lower()
            return response in ['y', 'yes']
        except (EOFError, KeyboardInterrupt):
            print(f"\n{Colors.RED}Installation cancelled.{Colors.NC}")
            return False

def install_tools(selected_tools: Set[str], current_os: str, repo_root: Path, dry_run: bool = False) -> Dict[str, bool]:
    """Install all selected tools."""
    if dry_run:
        print(f"\n{Colors.YELLOW}═══════════════════════════════════════════════════════════{Colors.NC}")
        print(f"{Colors.YELLOW}  DRY RUN - No actual installation will occur{Colors.NC}")
        print(f"{Colors.YELLOW}═══════════════════════════════════════════════════════════{Colors.NC}\n")
    else:
        print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
        print(f"{Colors.PURPLE}  Installing Configurations{Colors.NC}")
        print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    # Group tools by category
    tools_by_category = {}
    for tool in selected_tools:
        for category, data in CATEGORIES.items():
            if tool in data['tools']:
                if category not in tools_by_category:
                    tools_by_category[category] = []
                tools_by_category[category].append(tool)
                break

    results = {}

    for category in sorted(tools_by_category.keys()):
        print(f"\n{Colors.BLUE}→ {CATEGORIES[category]['description']}{Colors.NC}")
        if dry_run:
            tools = sorted(tools_by_category[category])
            for tool in tools:
                print(f"  • {tool}")
            results[category] = True  # Pretend success in dry-run
        else:
            success = install_category(category, current_os, repo_root)
            results[category] = success

    return results

def install_category(category: str, current_os: str, repo_root: Path) -> bool:
    """Install configuration for a category."""
    script_dir = Path(__file__).parent
    installer_script = script_dir / f"install-{category}.sh"

    if not installer_script.exists():
        print(f"{Colors.YELLOW}  ⚠ No installer found for {category}{Colors.NC}")
        print("  You'll need to configure manually or create installer")
        return False

    try:
        result = subprocess.run(
            ['sh', str(installer_script), current_os, str(repo_root)],
            capture_output=True,
            text=True
        )

        if result.returncode == 0:
            print(f"{Colors.GREEN}  ✓ Successfully installed {category}{Colors.NC}")
            return True
        else:
            print(f"{Colors.RED}  ✗ Failed to install {category}{Colors.NC}")
            if result.stderr:
                print(f"  Error: {result.stderr.strip()}")
            return False

    except Exception as e:
        print(f"{Colors.RED}  ✗ Error running installer: {e}{Colors.NC}")
        return False

def print_summary(results: Dict[str, bool], total_tools: int):
    """Print installation summary."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Installation Complete{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    print(f"{Colors.GREEN}✓ Installation completed!{Colors.NC}\n")

    success_count = sum(1 for s in results.values() if s)
    fail_count = len(results) - success_count

    print("Summary:")
    print(f"  Tools to configure: {Colors.GREEN}{total_tools}{Colors.NC}")
    print(f"  Categories installed: {Colors.GREEN}{success_count}{Colors.NC}")
    print(f"  Categories failed: {Colors.RED}{fail_count}{Colors.NC}\n")

    print("Next steps:")
    print("  1. Restart your shell or run: source ~/.config/shell/rc")
    print("  2. Check each tool's configuration")
    print("  3. Customize as needed\n")

    if fail_count > 0:
        print(f"{Colors.YELLOW}Note: Some categories failed to install.{Colors.NC}")
        print("      See output above for details.\n")
    else:
        print(f"{Colors.YELLOW}Note: Some tools may require manual installation{Colors.NC}")
        print("      See individual tool READMEs for details\n")

def get_tools_from_cli(tools_str: str, categories_str: str) -> Set[str]:
    """Get tools from command-line arguments."""
    selected_tools = set()

    # Parse --tools argument
    if tools_str:
        tools_list = [t.strip() for t in tools_str.split(',')]
        selected_tools.update(tools_list)

    # Parse --categories argument
    if categories_str:
        categories_list = [c.strip() for c in categories_str.split(',')]
        for category in categories_list:
            if category in CATEGORIES:
                selected_tools.update(CATEGORIES[category]['tools'])
            else:
                print(f"{Colors.YELLOW}Warning: Unknown category '{category}'{Colors.NC}")

    return selected_tools

# TUI Installer (only available if curses is available)
if HAS_CURSES:
	class TUIInstaller:
		def __init__(self, stdscr):
			self.stdscr = stdscr
			self.current_os = detect_os()
			self.selected_tools = set()
			self.current_screen = 'welcome'
			self.categories_list = list(CATEGORIES.keys())
			self.tool_selections = {}  # category -> set of selected tools

			# Navigation state
			self.cursor_pos = 0  # Current highlighted item
			self.max_items = 1   # Number of items on current screen

			# Initialize tool selections (all unselected)
			for category in CATEGORIES:
				self.tool_selections[category] = set()

			# Set up curses
			curses.curs_set(0)  # Hide cursor
			curses.noecho()
			self.stdscr.keypad(1)
			curses.mousemask(curses.ALL_MOUSE_EVENTS | curses.REPORT_MOUSE_POSITION)

			# Initialize colors
			curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
			curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)
			curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)
			curses.init_pair(4, curses.COLOR_BLUE, curses.COLOR_BLACK)
			curses.init_pair(5, curses.COLOR_MAGENTA, curses.COLOR_BLACK)
			curses.init_pair(6, curses.COLOR_WHITE, curses.COLOR_BLUE)
			curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_CYAN)
			curses.init_pair(8, curses.COLOR_BLACK, curses.COLOR_WHITE)

			self.CYAN = curses.color_pair(1) | curses.A_BOLD
			self.GREEN = curses.color_pair(2) | curses.A_BOLD
			self.YELLOW = curses.color_pair(3) | curses.A_BOLD
			self.BLUE = curses.color_pair(4)
			self.MAGENTA = curses.color_pair(5) | curses.A_BOLD
			self.SELECTED = curses.color_pair(6)
			self.SELECTED_CYAN = curses.color_pair(7)
			self.HIGHLIGHT = curses.color_pair(8)
			self.HIGHLIGHT_BOLD = curses.color_pair(8) | curses.A_BOLD | curses.A_UNDERLINE

		def clear_screen(self):
			"""Clear the screen"""
			self.stdscr.clear()
			self.stdscr.refresh()

		def draw_header(self, title: str):
			"""Draw header bar"""
			height, width = self.stdscr.getmaxyx()
			try:
				self.stdscr.addstr(0, 0, " " * width, self.MAGENTA)
				self.stdscr.addstr(0, 2, f" {title} ", self.MAGENTA)
			except curses.error:
				pass
			return 2

		def draw_footer(self, instructions: str):
			"""Draw footer with instructions"""
			height, width = self.stdscr.getmaxyx()
			try:
				self.stdscr.addstr(height - 1, 0, " " * width, self.BLUE)
				self.stdscr.addstr(height - 1, 2, f" {instructions} ", self.BLUE)
			except curses.error:
				pass

		def draw_button(self, y: int, x: int, text: str, selected: bool = False, is_cursor: bool = False):
			"""Draw a clickable button"""
			if is_cursor:
				color = self.HIGHLIGHT_BOLD
			elif selected:
				color = self.SELECTED
			else:
				color = self.CYAN

			button_text = f"[ {text} ]"
			try:
				self.stdscr.addstr(y, x, button_text, color)
			except curses.error:
				pass

			return len(button_text)

		def draw_list_item(self, y: int, x: int, text: str, is_cursor: bool = False):
			"""Draw a list item with optional cursor highlight"""
			if is_cursor:
				try:
					self.stdscr.addstr(y, x, f"► {text}", self.HIGHLIGHT_BOLD)
				except curses.error:
					pass
			else:
				try:
					self.stdscr.addstr(y, x + 2, f"  {text}", self.CYAN)
				except curses.error:
					pass

		def draw_checkbox(self, y: int, x: int, text: str, checked: bool, is_cursor: bool = False):
			"""Draw a checkbox item"""
			if is_cursor:
				color = self.HIGHLIGHT_BOLD
				prefix = "► "
			else:
				color = self.CYAN
				prefix = "  "

			box = "[✓]" if checked else "[ ]"
			try:
				self.stdscr.addstr(y, x, f"{prefix}{box} {text}", color)
			except curses.error:
				pass

		def screen_welcome(self):
			"""Welcome screen"""
			self.current_screen = 'welcome'
			self.cursor_pos = 0
			self.max_items = 1  # Only Start button

			self.clear_screen()

			line = self.draw_header("Greg's Dotfiles Installer - TUI Mode")
			line += 2

			welcome_text = [
				f"Detected OS: {self.current_os.capitalize()}",
				"",
				"Welcome to the interactive dotfiles installer!",
				"",
				"Features:",
				"  • Mouse support - click buttons to navigate",
				"  • Arrow keys and Enter also work",
				"  • Toggle tools with single click",
				"  • Visual selection status",
				"",
				"Click 'Start' or press Enter to continue",
				"Press 'q' to quit at any time",
			]

			for text in welcome_text:
				try:
					color = self.GREEN if "Detected OS" in text else self.CYAN
					self.stdscr.addstr(line, 4, text, color)
				except curses.error:
					pass
				line += 1

			# Draw button
			line += 2
			self.draw_button(line, 4, "Start", is_cursor=(self.cursor_pos == 0))

			self.draw_footer("↑↓: Navigate | Enter: Start | q: Quit")
			return line

		def screen_profiles(self):
			"""Profile selection screen"""
			self.current_screen = 'profiles'
			self.clear_screen()

			line = self.draw_header("Select Installation Profile")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Choose a profile:", self.CYAN)
			except curses.error:
				pass
			line += 2

			profile_list = list(PROFILES.keys())
			profiles_with_custom = profile_list + ['custom']

			# Reset cursor if out of bounds
			if self.cursor_pos >= len(profiles_with_custom):
				self.cursor_pos = 0
			self.max_items = len(profiles_with_custom)

			self.profile_buttons = []

			for idx, profile_key in enumerate(profiles_with_custom):
				button_y = line + idx * 2

				if profile_key == 'custom':
					name = "Custom"
					desc = "Choose specific tools manually"
				else:
					profile = PROFILES[profile_key]
					name = profile['name']
					desc = profile['description']

				# Draw highlighted or normal
				if idx == self.cursor_pos:
					try:
						self.stdscr.addstr(button_y, 8, f"► {name}", self.HIGHLIGHT_BOLD)
						self.stdscr.addstr(button_y + 1, 10, desc, self.GREEN)
					except curses.error:
						pass
				else:
					try:
						self.stdscr.addstr(button_y, 10, name, self.CYAN | curses.A_BOLD)
						self.stdscr.addstr(button_y + 1, 12, desc, self.GREEN)
					except curses.error:
						pass

				# Store button position
				self.profile_buttons.append({
					'profile': profile_key,
					'y': button_y,
					'x': 8
				})

			self.draw_footer("↑↓: Navigate | Enter: Select | q: Quit")
			return {'screen': 'profiles', 'profiles': profiles_with_custom}

		def screen_categories(self):
			"""Category selection screen"""
			self.current_screen = 'categories'
			self.clear_screen()

			line = self.draw_header("Select Tools by Category")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Click category to edit tools:", self.CYAN)
			except curses.error:
				pass
			line += 2

			# Reset cursor if out of bounds
			if self.cursor_pos >= len(self.categories_list):
				self.cursor_pos = 0
			self.max_items = len(self.categories_list)

			self.category_buttons = []

			for idx, category in enumerate(self.categories_list):
				cat_y = line + idx
				desc = CATEGORIES[category]['description']
				tools = CATEGORIES[category]['tools']
				selected = sum(1 for t in tools if t in self.selected_tools)
				total = len(tools)

				# Selection status
				if selected == total:
					status = f"[All]"
					color = self.GREEN
				elif selected > 0:
					status = f"[{selected}/{total}]"
					color = self.YELLOW
				else:
					status = f"[None]"
					color = self.CYAN

				# Draw with cursor highlight
				if idx == self.cursor_pos:
					try:
						self.stdscr.addstr(cat_y, 6, f"► {desc}", self.HIGHLIGHT_BOLD)
						self.stdscr.addstr(cat_y, 40, status, color | curses.A_BOLD)
					except curses.error:
						pass
				else:
					try:
						self.stdscr.addstr(cat_y, 8, desc, self.CYAN | curses.A_BOLD)
						self.stdscr.addstr(cat_y, 42, status, color | curses.A_BOLD)
					except curses.error:
						pass

				# Store button position
				self.category_buttons.append({
					'category': category,
					'y': cat_y,
					'x': 6,
					'width': len(desc)
				})

			# Action buttons at bottom
			button_y = cat_y + 2

			# We have 2 extra items: Accept and Back
			self.max_items = len(self.categories_list) + 2

			# Adjust cursor for action buttons
			adj_cursor = self.cursor_pos - len(self.categories_list)

			self.draw_button(button_y, 6, "Accept", is_cursor=(self.cursor_pos >= len(self.categories_list) and adj_cursor == 0))
			self.draw_button(button_y, 22, "Back", is_cursor=(self.cursor_pos >= len(self.categories_list) and adj_cursor == 1))

			self.draw_footer("↑↓: Navigate | Enter: Select/Action | q: Quit")
			return {'screen': 'categories', 'button_y': button_y}

		def screen_tools(self, category: str):
			"""Tool selection within a category"""
			self.current_screen = 'tools'
			self.clear_screen()

			desc = CATEGORIES[category]['description']
			tools = CATEGORIES[category]['tools']

			line = self.draw_header(desc)
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Click tools to toggle:", self.CYAN)
			except curses.error:
				pass
			line += 2

			# Reset cursor if out of bounds
			if self.cursor_pos >= len(tools):
				self.cursor_pos = 0
			self.max_items = len(tools)

			self.tool_buttons = []

			# Two columns
			for idx, tool in enumerate(tools):
				col = idx // 10
				row = idx % 10
				y = line + row
				x = 8 + col * 28

				is_selected = tool in self.tool_selections[category]

				self.draw_checkbox(y, x, tool, is_selected, is_cursor=(idx == self.cursor_pos))

				# Store button position
				self.tool_buttons.append({
					'tool': tool,
					'y': y,
					'x': x,
					'width': len(tool) + 5
				})

			# Action buttons
			button_y = y + 2
			# We have 3 extra items: All, None, Done
			self.max_items = len(tools) + 3
			adj_cursor = self.cursor_pos - len(tools)

			self.draw_button(button_y, 8, "All", is_cursor=(adj_cursor == 0))
			self.draw_button(button_y, 22, "None", is_cursor=(adj_cursor == 1))
			self.draw_button(button_y, 36, "Done", is_cursor=(adj_cursor == 2))

			self.draw_footer("↑↓: Navigate | Space: Toggle | Enter: Action | q: Quit")
			return {'screen': 'tools', 'category': category, 'button_y': button_y}

		def screen_confirm(self):
			"""Confirmation screen"""
			self.current_screen = 'confirm'
			self.clear_screen()

			line = self.draw_header("Confirm Installation")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Summary of selections:", self.CYAN | curses.A_BOLD)
			except curses.error:
				pass
			line += 1
			try:
				self.stdscr.addstr(line, 4, f"Total tools: {len(self.selected_tools)}", self.GREEN | curses.A_BOLD)
			except curses.error:
				pass
			line += 2

			# Group tools by category
			tools_by_category = {}
			for tool in self.selected_tools:
				for category, data in CATEGORIES.items():
					if tool in data['tools']:
						if category not in tools_by_category:
							tools_by_category[category] = []
						tools_by_category[category].append(tool)
						break

			# Display selections (compact format)
			for category in sorted(tools_by_category.keys()):
				cat_desc = CATEGORIES[category]['description']
				tools = sorted(tools_by_category[category])

				try:
					self.stdscr.addstr(line, 4, f"{cat_desc}:", self.CYAN | curses.A_BOLD)
				except curses.error:
					pass
				line += 1

				# Truncate if too long
				tool_line = ", ".join(tools)
				if len(tool_line) > 60:
					tool_line = tool_line[:57] + "..."
				try:
					self.stdscr.addstr(line, 6, tool_line, self.GREEN)
				except curses.error:
					pass
				line += 1

			# Buttons - we have 2 items: Install and Cancel
			self.max_items = 2
			if self.cursor_pos >= self.max_items:
				self.cursor_pos = 0

			# Buttons
			line += 1
			self.draw_button(line, 6, "Install", is_cursor=(self.cursor_pos == 0))
			self.draw_button(line, 22, "Cancel", is_cursor=(self.cursor_pos == 1))

			self.draw_footer("↑↓: Navigate | Enter: Action | q: Quit")
			return {'screen': 'confirm', 'button_y': line}

		def handle_input(self, event, screen_data):
			"""Handle keyboard/mouse input"""
			action = None

			# Handle keyboard
			if event == curses.KEY_UP:
				self.cursor_pos = max(0, self.cursor_pos - 1)
				return 'redraw'

			elif event == curses.KEY_DOWN:
				self.cursor_pos = min(self.max_items - 1, self.cursor_pos + 1)
				return 'redraw'

			elif event == ord('q') or event == ord('Q'):
				return 'quit'

			elif event == curses.KEY_ENTER or event == 10 or event == 13:
				# Activate based on current screen and cursor position
				if self.current_screen == 'welcome':
					action = 'next'

				elif self.current_screen == 'profiles':
					profiles = screen_data.get('profiles', [])
					if 0 <= self.cursor_pos < len(profiles):
						selected = profiles[self.cursor_pos]
						action = f'profile_{selected}'

				elif self.current_screen == 'categories':
					if self.cursor_pos < len(self.categories_list):
						category = self.categories_list[self.cursor_pos]
						action = f'category_{category}'
					elif self.cursor_pos == len(self.categories_list):
						action = 'accept'
					else:
						action = 'back'

				elif self.current_screen == 'tools':
					tools = CATEGORIES[screen_data.get('category', '')]['tools']
					if self.cursor_pos < len(tools):
						# Toggle the tool
						tool = tools[self.cursor_pos]
						category = screen_data.get('category', '')
						if tool in self.tool_selections[category]:
							self.tool_selections[category].remove(tool)
							self.selected_tools.discard(tool)
						else:
							self.tool_selections[category].add(tool)
							self.selected_tools.add(tool)
						return 'redraw'
					else:
						adj_cursor = self.cursor_pos - len(tools)
						if adj_cursor == 0:
							action = 'select_all'
						elif adj_cursor == 1:
							action = 'select_none'
						else:
							action = 'done'

				elif self.current_screen == 'confirm':
					if self.cursor_pos == 0:
						action = 'install'
					else:
						action = 'cancel'

			elif event == 32:  # Space bar - toggle checkbox
				if self.current_screen == 'tools':
					tools = CATEGORIES[screen_data.get('category', '')]['tools']
					if self.cursor_pos < len(tools):
						tool = tools[self.cursor_pos]
						category = screen_data.get('category', '')
						if tool in self.tool_selections[category]:
							self.tool_selections[category].remove(tool)
							self.selected_tools.discard(tool)
						else:
							self.tool_selections[category].add(tool)
							self.selected_tools.add(tool)
						return 'redraw'

			# Handle mouse
			elif event == curses.KEY_MOUSE:
				try:
					_, mx, my, _, bstate = curses.getmouse()
					# Check for left click
					if bstate & curses.BUTTON1_CLICKED:
						# Welcome screen
						if self.current_screen == 'welcome':
							if my == screen_data.get('button_line', 0) + 2 and 4 <= mx <= 14:
								action = 'next'

						# Profiles screen
						elif self.current_screen == 'profiles':
							for btn in self.profile_buttons:
								if btn['y'] == my and 6 <= mx <= 30:
									action = f'profile_{btn["profile"]}'
									self.cursor_pos = self.profile_buttons.index(btn)

						# Categories screen
						elif self.current_screen == 'categories':
							for btn in self.category_buttons:
								if (btn['y'] == my and
									btn['x'] <= mx <= btn['x'] + btn['width']):
									action = f'category_{btn["category"]}'
									self.cursor_pos = self.category_buttons.index(btn)
									break

							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								if 6 <= mx <= 15:  # Accept
									action = 'accept'
									self.cursor_pos = len(self.categories_list)
								elif 22 <= mx <= 29:  # Back
									action = 'back'
									self.cursor_pos = len(self.categories_list) + 1

						# Tools screen
						elif self.current_screen == 'tools':
							category = screen_data.get('category', '')
							for btn in self.tool_buttons:
								if (btn['y'] == my and
									btn['x'] <= mx <= btn['x'] + btn['width']):
									tool = btn['tool']
									self.cursor_pos = self.tool_buttons.index(btn)
									if tool in self.tool_selections[category]:
										self.tool_selections[category].remove(tool)
										self.selected_tools.discard(tool)
									else:
										self.tool_selections[category].add(tool)
										self.selected_tools.add(tool)
									return 'redraw'

							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								tools = CATEGORIES[category]['tools']
								if 8 <= mx <= 14:  # All
									action = 'select_all'
									self.cursor_pos = len(tools)
								elif 22 <= mx <= 29:  # None
									action = 'select_none'
									self.cursor_pos = len(tools) + 1
								elif 36 <= mx <= 43:  # Done
									action = 'done'
									self.cursor_pos = len(tools) + 2

						# Confirm screen
						elif self.current_screen == 'confirm':
							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								if 6 <= mx <= 16:  # Install
									action = 'install'
									self.cursor_pos = 0
								elif 22 <= mx <= 31:  # Cancel
									action = 'cancel'
									self.cursor_pos = 1
				except curses.error:
					pass

			return action

		def run(self):
			"""Main TUI loop"""
			screen_data = self.screen_welcome()
			selected_profile = None

			while True:
				# Draw current screen
				if self.current_screen == 'welcome':
					screen_data = self.screen_welcome()
				elif self.current_screen == 'profiles':
					screen_data = self.screen_profiles()
				elif self.current_screen == 'categories':
					screen_data = self.screen_categories()
				elif self.current_screen == 'tools':
					screen_data = self.screen_tools(screen_data.get('category', ''))
				elif self.current_screen == 'confirm':
					screen_data = self.screen_confirm()

				self.stdscr.refresh()

				# Get input
				event = self.stdscr.getch()
				action = self.handle_input(event, screen_data)

				# Handle 'redraw' action (no state change, just refresh)
				if action == 'redraw':
					continue

				# Handle other actions
				if action == 'quit':
					return None

				elif action == 'next' or action == 'profile_1':
					selected_profile = 'minimal'
					self.selected_tools = get_tools_from_profile(selected_profile)
					# Initialize selections
					for category in CATEGORIES:
						self.tool_selections[category] = set()
					for tool in self.selected_tools:
						for category, data in CATEGORIES.items():
							if tool in data['tools']:
								self.tool_selections[category].add(tool)
								break
					self.cursor_pos = 0
					screen_data = self.screen_categories()

				elif action == 'back':
					self.selected_tools = set()
					self.cursor_pos = 0
					screen_data = self.screen_profiles()

				elif action.startswith('profile_'):
					profile_key = action.split('_', 1)[1]
					if profile_key != 'custom':
						selected_profile = profile_key
						self.selected_tools = get_tools_from_profile(profile_key)
						# Initialize selections
						for category in CATEGORIES:
							self.tool_selections[category] = set()
						for tool in self.selected_tools:
							for category, data in CATEGORIES.items():
								if tool in data['tools']:
									self.tool_selections[category].add(tool)
									break
					else:
						selected_profile = None
						self.selected_tools = set()
					self.cursor_pos = 0
					screen_data = self.screen_categories()

				elif action.startswith('category_'):
					category = action.split('_', 1)[1]
					self.cursor_pos = 0
					screen_data = self.screen_tools(category)

				elif action == 'select_all':
					category = screen_data.get('category', '')
					for tool in CATEGORIES[category]['tools']:
						self.tool_selections[category].add(tool)
						self.selected_tools.add(tool)
					return 'redraw'

				elif action == 'select_none':
					category = screen_data.get('category', '')
					for tool in CATEGORIES[category]['tools']:
						self.tool_selections[category].discard(tool)
						self.selected_tools.discard(tool)
					return 'redraw'

				elif action == 'done':
					self.cursor_pos = 0
					screen_data = self.screen_categories()

				elif action == 'accept':
					if self.selected_tools:
						self.cursor_pos = 0
						screen_data = self.screen_confirm()

				elif action == 'install':
					return self.selected_tools

				elif action == 'cancel':
					self.cursor_pos = 0
					screen_data = self.screen_categories()
				try:
					self.stdscr.addstr(line, 4, text, self.GREEN if "Detected OS" in text else self.CYAN)
				except curses.error:
					pass
				line += 1

			# Draw button
			line += 2
			self.draw_button(line, 4, "Start", True)

			self.draw_footer("Enter: Start | q: Quit")
			return line

		def screen_profiles(self):
			"""Profile selection screen"""
			self.current_screen = 'profiles'
			self.clear_screen()

			line = self.draw_header("Select Installation Profile")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Choose a profile:", self.CYAN)
			except curses.error:
				pass
			line += 2

			profile_list = list(PROFILES.keys())
			profiles_with_custom = profile_list + ['custom']

			self.profile_buttons = []

			for idx, profile_key in enumerate(profiles_with_custom):
				button_y = line + idx * 2

				if profile_key == 'custom':
					name = "Custom"
					desc = "Choose specific tools manually"
				else:
					profile = PROFILES[profile_key]
					name = profile['name']
					desc = profile['description']

				try:
					self.stdscr.addstr(button_y, 6, name, self.CYAN | curses.A_BOLD)
					self.stdscr.addstr(button_y + 1, 8, desc, self.GREEN)
				except curses.error:
					pass

				# Store button position
				self.profile_buttons.append({
					'profile': profile_key,
					'y': button_y,
					'x': 6
				})

			# Draw buttons at bottom
			button_y = button_y + 2
			for idx in range(min(len(profiles_with_custom), 6)):
				self.draw_button(button_y, 6 + idx * 18, str(idx + 1), idx == 0)

			self.draw_footer("1-6: Select profile | q: Quit")
			return {'screen': 'profiles', 'profiles': profiles_with_custom}

		def screen_categories(self):
			"""Category selection screen"""
			self.current_screen = 'categories'
			self.clear_screen()

			line = self.draw_header("Select Tools by Category")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Click category to edit tools:", self.CYAN)
			except curses.error:
				pass
			line += 2

			self.category_buttons = []

			for idx, category in enumerate(self.categories_list):
				cat_y = line + idx
				desc = CATEGORIES[category]['description']
				tools = CATEGORIES[category]['tools']
				selected = sum(1 for t in tools if t in self.selected_tools)
				total = len(tools)

				# Selection status
				if selected == total:
					status = f"[All]"
					color = self.GREEN
				elif selected > 0:
					status = f"[{selected}/{total}]"
					color = self.YELLOW
				else:
					status = f"[None]"
					color = self.CYAN

				try:
					self.stdscr.addstr(cat_y, 6, desc, self.CYAN | curses.A_BOLD)
					self.stdscr.addstr(cat_y, 35, status, color | curses.A_BOLD)
				except curses.error:
					pass

				# Store button position
				self.category_buttons.append({
					'category': category,
					'y': cat_y,
					'x': 6,
					'width': len(desc)
				})

			# Action buttons
			button_y = cat_y + 2
			self.draw_button(button_y, 6, "Accept", True)
			self.draw_button(button_y, 22, "Back")

			self.draw_footer("Click category to edit | Accept when done | q: Quit")
			return {'screen': 'categories', 'button_y': button_y}

		def screen_tools(self, category: str):
			"""Tool selection within a category"""
			self.current_screen = 'tools'
			self.clear_screen()

			desc = CATEGORIES[category]['description']
			tools = CATEGORIES[category]['tools']

			line = self.draw_header(desc)
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Click tools to toggle:", self.CYAN)
			except curses.error:
				pass
			line += 2

			self.tool_buttons = []

			# Two columns
			for idx, tool in enumerate(tools):
				col = idx // 10
				row = idx % 10
				y = line + row
				x = 8 + col * 28

				is_selected = tool in self.tool_selections[category]
				status = "[✓]" if is_selected else "[ ]"
				color = self.GREEN if is_selected else self.CYAN

				try:
					self.stdscr.addstr(y, x, status, color | curses.A_BOLD)
					self.stdscr.addstr(y, x + 5, tool, self.GREEN)
				except curses.error:
					pass

				# Store button position
				self.tool_buttons.append({
					'tool': tool,
					'y': y,
					'x': x,
					'width': len(tool) + 5
				})

			# Action buttons
			button_y = y + 2
			self.draw_button(button_y, 8, "All")
			self.draw_button(button_y, 22, "None")
			self.draw_button(button_y, 36, "Done", True)

			self.draw_footer("Click tool to toggle | Done when finished | q: Quit")
			return {'screen': 'tools', 'category': category, 'button_y': button_y}

		def screen_confirm(self):
			"""Confirmation screen"""
			self.current_screen = 'confirm'
			self.clear_screen()

			line = self.draw_header("Confirm Installation")
			line += 2

			try:
				self.stdscr.addstr(line, 4, "Summary of selections:", self.CYAN | curses.A_BOLD)
			except curses.error:
				pass
			line += 1
			try:
				self.stdscr.addstr(line, 4, f"Total tools: {len(self.selected_tools)}", self.GREEN | curses.A_BOLD)
			except curses.error:
				pass
			line += 2

			# Group tools by category
			tools_by_category = {}
			for tool in self.selected_tools:
				for category, data in CATEGORIES.items():
					if tool in data['tools']:
						if category not in tools_by_category:
							tools_by_category[category] = []
						tools_by_category[category].append(tool)
						break

			# Display selections (compact format)
			for category in sorted(tools_by_category.keys()):
				cat_desc = CATEGORIES[category]['description']
				tools = sorted(tools_by_category[category])

				try:
					self.stdscr.addstr(line, 4, f"{cat_desc}:", self.CYAN | curses.A_BOLD)
				except curses.error:
					pass
				line += 1

				# Truncate if too long
				tool_line = ", ".join(tools)
				if len(tool_line) > 60:
					tool_line = tool_line[:57] + "..."
				try:
					self.stdscr.addstr(line, 6, tool_line, self.GREEN)
				except curses.error:
					pass
				line += 1

			# Buttons
			line += 1
			self.draw_button(line, 6, "Install", True)
			self.draw_button(line, 22, "Cancel")

			self.draw_footer("Click Install to proceed | Cancel to abort | q: Quit")
			return {'screen': 'confirm', 'button_y': line}

		def handle_input(self, event, screen_data):
			"""Handle keyboard/mouse input"""
			action = None

			# Handle mouse
			if event == curses.KEY_MOUSE:
				try:
					_, mx, my, _, bstate = curses.getmouse()
					# Check for left click
					if bstate & curses.BUTTON1_CLICKED:
						# Welcome screen
						if self.current_screen == 'welcome':
							if my == screen_data.get('button_line', 0) + 2:
								action = 'next'

						# Profiles screen
						elif self.current_screen == 'profiles':
							for btn in self.profile_buttons:
								if btn['y'] == my and 6 <= mx <= 30:
									action = f'profile_{btn["profile"]}'

						# Categories screen
						elif self.current_screen == 'categories':
							for btn in self.category_buttons:
								if (btn['y'] == my and
									btn['x'] <= mx <= btn['x'] + btn['width']):
									action = f'category_{btn["category"]}'

							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								if 6 <= mx <= 15:  # Accept
									action = 'accept'
								elif 22 <= mx <= 29:  # Back
									action = 'back'

						# Tools screen
						elif self.current_screen == 'tools':
							category = screen_data.get('category', '')
							for btn in self.tool_buttons:
								if (btn['y'] == my and
									btn['x'] <= mx <= btn['x'] + btn['width']):
									action = f'toggle_{btn["tool"]}'

							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								if 8 <= mx <= 14:  # All
									action = 'select_all'
								elif 22 <= mx <= 29:  # None
									action = 'select_none'
								elif 36 <= mx <=	43:  # Done
									action = 'done'

						# Confirm screen
						elif self.current_screen == 'confirm':
							button_y = screen_data.get('button_y', 0)
							if my == button_y:
								if 6 <= mx <= 16:  # Install
									action = 'install'
								elif 22 <= mx <= 31:  # Cancel
									action = 'cancel'
				except curses.error:
					pass

			# Handle keyboard
			elif event == ord('q') or event == ord('Q'):
				return 'quit'

			elif event == curses.KEY_ENTER or event == 10 or event == 13:
				if self.current_screen == 'welcome':
					action = 'next'
				elif self.current_screen == 'categories':
					action = 'accept'
				elif self.current_screen == 'tools':
					action = 'done'
				elif self.current_screen == 'confirm':
					action = 'install'

			return action

		def run(self):
			"""Main TUI loop"""
			screen_data = self.screen_welcome()
			selected_profile = None

			while True:
				# Draw current screen
				if self.current_screen == 'welcome':
					screen_data = self.screen_welcome()
				elif self.current_screen == 'profiles':
					screen_data = self.screen_profiles()
				elif self.current_screen == 'categories':
					screen_data = self.screen_categories()
				elif self.current_screen == 'tools':
					screen_data = self.screen_tools(screen_data.get('category', ''))
				elif self.current_screen == 'confirm':
					screen_data = self.screen_confirm()

				self.stdscr.refresh()

				# Get input
				event = self.stdscr.getch()
				action = self.handle_input(event, screen_data)

				# Handle action
				if action == 'quit':
					return None

				elif action == 'next' or action == 'profile_1':
					selected_profile = 'minimal'
					self.selected_tools = get_tools_from_profile(selected_profile)
					# Initialize selections
					for category in CATEGORIES:
						self.tool_selections[category] = set()
					for tool in self.selected_tools:
						for category, data in CATEGORIES.items():
							if tool in data['tools']:
								self.tool_selections[category].add(tool)
								break
					screen_data = self.screen_categories()

				elif action == 'back':
					self.selected_tools = set()
					screen_data = self.screen_profiles()

				elif action.startswith('profile_'):
					profile_key = action.split('_', 1)[1]
					if profile_key != 'custom':
						selected_profile = profile_key
						self.selected_tools = get_tools_from_profile(profile_key)
						# Initialize selections
						for category in CATEGORIES:
							self.tool_selections[category] = set()
						for tool in self.selected_tools:
							for category, data in CATEGORIES.items():
								if tool in data['tools']:
									self.tool_selections[category].add(tool)
									break
					else:
						selected_profile = None
						self.selected_tools = set()
					screen_data = self.screen_categories()

				elif action.startswith('category_'):
					category = action.split('_', 1)[1]
					screen_data = self.screen_tools(category)

				elif action.startswith('toggle_'):
					tool = action.split('_', 1)[1]
					category = screen_data.get('category', '')
					if tool in self.tool_selections[category]:
						self.tool_selections[category].remove(tool)
						self.selected_tools.discard(tool)
					else:
						self.tool_selections[category].add(tool)
						self.selected_tools.add(tool)

				elif action == 'select_all':
					category = screen_data.get('category', '')
					for tool in CATEGORIES[category]['tools']:
						self.tool_selections[category].add(tool)
						self.selected_tools.add(tool)

				elif action == 'select_none':
					category = screen_data.get('category', '')
					for tool in CATEGORIES[category]['tools']:
						self.tool_selections[category].discard(tool)
						self.selected_tools.discard(tool)

				elif action == 'done':
					screen_data = self.screen_categories()

				elif action == 'accept':
					if self.selected_tools:
						screen_data = self.screen_confirm()

				elif action == 'install':
					return self.selected_tools

				elif action == 'cancel':
					screen_data = self.screen_categories()

def run_tui():
	"""Run TUI installer"""
	if not HAS_CURSES:
		print("Error: TUI mode requires curses library")
		print("Install it with: pip install windows-curses  (on Windows)")
		print("It should be available by default on Linux/macOS")
		sys.exit(1)

	selected_tools = curses.wrapper(lambda stdscr: TUIInstaller(stdscr).run())

	if selected_tools:
		# Perform installation
		current_os = detect_os()
		repo_root = Path(__file__).parent.parent.parent

		print(f"\nInstalling {len(selected_tools)} tools...\n")

		results = install_tools(selected_tools, current_os, repo_root)

		# Print summary
		success_count = sum(1 for s in results.values() if s)
		fail_count = len(results) - success_count

		print(f"\n{'='*60}")
		print("Installation Complete")
		print(f"{'='*60}\n")
		print(f"  Tools to configure: {len(selected_tools)}")
		print(f"  Categories installed: {success_count}")
		print(f"  Categories failed: {fail_count}\n")

		if fail_count > 0:
			print("Note: Some categories failed to install.")
			print("      See output above for details.\n")
	else:
		print("\nInstallation cancelled.")

def main():
    """Main installation flow."""
    # Parse command-line arguments
    args = parse_args()

    # Check if TUI mode is requested
    if args.tui:
        run_tui()
        return

    # Detect OS
    current_os = detect_os()

    # Determine if we're in non-interactive mode
    non_interactive = args.profile or args.tools or args.categories

    # Select tools
    selected_tools = None

    if args.profile:
        # Profile specified via CLI
        selected_tools = get_tools_from_profile(args.profile)
        profile_name = PROFILES[args.profile]['name']
        print(f"{Colors.GREEN}Selected profile: {profile_name}{Colors.NC}")
    elif args.tools or args.categories:
        # Tools/categories specified via CLI
        selected_tools = get_tools_from_cli(args.tools or '', args.categories or '')
        print(f"{Colors.GREEN}Selected {len(selected_tools)} tools from CLI arguments{Colors.NC}")
    else:
        # Interactive mode
        print_header()
        print_system_info(current_os)

        try:
            input(f"{Colors.YELLOW}Press Enter to continue...{Colors.NC}")
        except (EOFError, KeyboardInterrupt):
            print()

        # Select profile
        profile_key = select_profile()

        # Get tools
        if profile_key:
            selected_tools = get_tools_from_profile(profile_key)
            profile_name = PROFILES[profile_key]['name']
            print(f"\n{Colors.GREEN}Selected profile: {profile_name}{Colors.NC}")
        else:
            selected_tools = None
            print(f"\n{Colors.GREEN}Custom tool selection{Colors.NC}")

        # Select/customize tools
        selected_tools = select_categories(selected_tools)

    if not selected_tools:
        print(f"{Colors.RED}No tools selected. Exiting.{Colors.NC}")
        sys.exit(1)

    # Confirm installation (skip if --yes or non-interactive with --profile)
    if args.yes or (non_interactive and args.profile):
        # Auto-confirm in non-interactive mode
        pass
    elif non_interactive:
        # Still confirm if tools/categories specified
        print(f"\n{Colors.BOLD}Summary of selections:{Colors.NC}\n")
        print(f"  Total tools: {Colors.GREEN}{len(selected_tools)}{Colors.NC}")
        if not args.yes:
            # Still need confirmation for explicit tool selection
            print(f"\n{Colors.YELLOW}Use --yes to auto-confirm{Colors.NC}")
            if not confirm_install(selected_tools, current_os):
                print(f"{Colors.RED}Installation cancelled.{Colors.NC}")
                sys.exit(0)
    else:
        # Interactive confirmation
        if not confirm_install(selected_tools, current_os):
            print(f"{Colors.RED}Installation cancelled.{Colors.NC}")
            sys.exit(0)

    # Install tools
    repo_root = Path(__file__).parent.parent.parent
    results = install_tools(selected_tools, current_os, repo_root, dry_run=args.dry_run)

    # Print summary
    if args.dry_run:
        print(f"\n{Colors.YELLOW}Dry run complete. No actual installation occurred.{Colors.NC}")
    else:
        print_summary(results, len(selected_tools))

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.RED}Installation interrupted by user.{Colors.NC}")
        sys.exit(130)
    except Exception as e:
        print(f"\n{Colors.RED}Unexpected error: {e}{Colors.NC}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
