#!/usr/bin/env python3
"""
Interactive installer for Greg's Dotfiles
Detects OS and lets user choose which tools to configure
"""

import os
import sys
import subprocess
from pathlib import Path
from typing import List, Dict, Optional

# ANSI color codes
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    NC = '\033[0m'  # No Color

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

def print_header():
    """Print the installer header."""
    # Clear screen
    os.system('clear' if os.name != 'nt' else 'cls')

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
    print("  • Select which tools to configure")
    print("  • Install tools (optional)")
    print("  • Apply OS-specific configuration layers")
    print("  • Create symlinks to your home directory")
    print()

    input(f"{Colors.YELLOW}Press Enter to continue...{Colors.NC}")

def select_categories() -> List[str]:
    """Let user select categories."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Step 1: Select Categories{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    print("Select which categories of tools you want to configure:\n")

    # Display categories
    category_list = list(CATEGORIES.keys())
    for i, cat in enumerate(category_list, 1):
        desc = CATEGORIES[cat]['description']
        print(f"  {Colors.CYAN}{i}){Colors.NC} {desc}")
    print(f"  {Colors.CYAN}a){Colors.NC} All categories\n")

    # Get selection
    while True:
        try:
            selection = input(f"{Colors.YELLOW}→ Selection [1-{len(category_list)} or 'a' for all]: {Colors.NC}").strip().lower()

            if selection in ['a', 'all']:
                return category_list

            # Parse selection
            selected = []
            for num in selection.split():
                try:
                    idx = int(num) - 1
                    if 0 <= idx < len(category_list):
                        selected.append(category_list[idx])
                except ValueError:
                    pass

            if selected:
                return selected

            print(f"{Colors.RED}Invalid selection. Please try again.{Colors.NC}")
        except (EOFError, KeyboardInterrupt):
            print(f"\n{Colors.RED}Installation cancelled.{Colors.NC}")
            sys.exit(0)

def confirm_install(selected_categories: List[str], current_os: str) -> bool:
    """Confirm installation with user."""
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Step 2: Confirm Installation{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    print("Summary of selections:\n")

    for category in selected_categories:
        print(f"{Colors.CYAN}{category}:{Colors.NC}")
        for tool in CATEGORIES[category]['tools']:
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

def install_category(category: str, current_os: str, repo_root: Path):
    """Install configuration for a category."""
    print(f"\n{Colors.GREEN}Installing {category}...{Colors.NC}")

    script_dir = Path(__file__).parent
    installer_script = script_dir / f"install-{category}.sh"

    if not installer_script.exists():
        print(f"{Colors.YELLOW}  No installer found for {category}{Colors.NC}")
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

def main():
    """Main installation flow."""
    # Detect OS
    current_os = detect_os()

    # Welcome
    welcome(current_os)

    # Select categories
    selected_categories = select_categories()

    if not selected_categories:
        print(f"{Colors.RED}No categories selected. Exiting.{Colors.NC}")
        sys.exit(1)

    # Confirm installation
    if not confirm_install(selected_categories, current_os):
        print(f"{Colors.RED}Installation cancelled.{Colors.NC}")
        sys.exit(0)

    # Install configurations
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Installing Configurations{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    repo_root = Path(__file__).parent.parent.parent
    success_count = 0
    fail_count = 0

    for category in selected_categories:
        if install_category(category, current_os, repo_root):
            success_count += 1
        else:
            fail_count += 1

    # Print summary
    print(f"\n{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.PURPLE}  Installation Complete{Colors.NC}")
    print(f"{Colors.PURPLE}═══════════════════════════════════════════════════════════{Colors.NC}\n")

    print(f"{Colors.GREEN}✓ Installation completed!{Colors.NC}\n")
    print("Summary:")
    print(f"  {Colors.GREEN}Successful:{Colors.NC} {success_count}")
    print(f"  {Colors.RED}Failed:{Colors.NC}     {fail_count}\n")

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

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.RED}Installation interrupted by user.{Colors.NC}")
        sys.exit(130)
    except Exception as e:
        print(f"\n{Colors.RED}Unexpected error: {e}{Colors.NC}")
        sys.exit(1)
