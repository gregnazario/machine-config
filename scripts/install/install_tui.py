#!/usr/bin/env python3
"""
TUI Installer for Greg's Dotfiles
Features mouse support and responsive navigation
"""

import curses
import os
import sys
import subprocess
from pathlib import Path
from typing import List, Dict, Set, Optional, Tuple

# Import data and functions from main installer
sys.path.insert(0, str(Path(__file__).parent))
from install import CATEGORIES, PROFILES, detect_os, get_tools_from_profile, install_tools

class Colors:
    """Color pairs for curses"""
    def __init__(self, stdscr):
        curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)
        curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)
        curses.init_pair(4, curses.COLOR_BLUE, curses.COLOR_BLACK)
        curses.init_pair(5, curses.COLOR_MAGENTA, curses.COLOR_BLACK)
        curses.init_pair(6, curses.COLOR_WHITE, curses.COLOR_BLUE)
        curses.init_pair(7, curses.COLOR_BLACK, curses.COLOR_CYAN)
        curses.init_pair(8, curses.COLOR_BLACK, curses.COLOR_GREEN)
        curses.init_pair(9, curses.COLOR_BLACK, curses.COLOR_YELLOW)

        self.CYAN = curses.color_pair(1)
        self.GREEN = curses.color_pair(2)
        self.YELLOW = curses.color_pair(3)
        self.BLUE = curses.color_pair(4)
        self.MAGENTA = curses.color_pair(5)
        self.SELECTED = curses.color_pair(6)
        self.SELECTED_CYAN = curses.color_pair(7)
        self.SELECTED_GREEN = curses.color_pair(8)
        self.SELECTED_YELLOW = curses.color_pair(9)
        self.BOLD = curses.A_BOLD

class TUIInstaller:
    def __init__(self, stdscr):
        self.stdscr = stdscr
        self.colors = Colors(stdscr)
        self.current_os = detect_os()
        self.selected_tools = set()
        self.current_screen = 'welcome'
        self.categories_list = list(CATEGORIES.keys())
        self.current_category_idx = 0
        self.tool_selections = {}  # category -> set of selected tools

        # Initialize tool selections (all unselected)
        for category in CATEGORIES:
            self.tool_selections[category] = set()

        # Enable mouse
        curses.mousemask(curses.ALL_MOUSE_EVENTS | curses.REPORT_MOUSE_POSITION)

        # Set up input
        self.stdscr.keypad(1)
        curses.curs_set(0)  # Hide cursor
        curses.noecho()

    def clear_screen(self):
        """Clear the screen"""
        self.stdscr.clear()
        self.stdscr.refresh()

    def draw_header(self, title: str):
        """Draw header bar"""
        height, width = self.stdscr.getmaxyx()
        header_text = f" {title} "

        # Draw header bar
        self.stdscr.attron(self.colors.MAGENTA | self.colors.BOLD)
        try:
            self.stdscr.addstr(0, 0, " " * width)
            self.stdscr.addstr(0, 0, header_text)
        except curses.error:
            pass
        self.stdscr.attroff(self.colors.MAGENTA | self.colors.BOLD)

        return 1  # Return next line

    def draw_footer(self, instructions: str):
        """Draw footer with instructions"""
        height, width = self.stdscr.getmaxyx()
        footer_text = f" {instructions} "

        # Draw footer bar
        self.stdscr.attron(self.colors.BLUE | self.colors.BOLD)
        try:
            self.stdscr.addstr(height - 1, 0, " " * width)
            self.stdscr.addstr(height - 1, 0, footer_text)
        except curses.error:
            pass
        self.stdscr.attroff(self.colors.BLUE | self.colors.BOLD)

    def draw_button(self, y: int, x: int, text: str, selected: bool = False, color=None):
        """Draw a clickable button"""
        if color is None:
            color = self.colors.SELECTED if selected else self.colors.CYAN
        if selected:
            color |= self.colors.BOLD

        button_text = f"[ {text} ]"
        try:
            self.stdscr.addstr(y, x, button_text, color)
        except curses.error:
            pass

        return len(button_text)

    def screen_welcome(self):
        """Welcome screen"""
        self.current_screen = 'welcome'
        self.clear_screen()

        line = self.draw_header("Greg's Dotfiles Installer")

        # Welcome message
        line += 2
        welcome_text = [
            f"Detected OS: {self.current_os.capitalize()}",
            "",
            "Welcome to the interactive dotfiles installer!",
            "",
            "This installer will help you:",
            "  • Select a profile or customize your tool selection",
            "  • Choose specific tools within categories",
            "  • Install tools (optional)",
            "  • Apply OS-specific configuration layers",
            "  • Create symlinks to your home directory",
            "",
            "Use mouse to click buttons or arrow keys + Enter to navigate",
        ]

        for text in welcome_text:
            try:
                self.stdscr.addstr(line, 2, text, self.colors.CYAN | self.colors.BOLD if "Detected OS" in text else self.colors.GREEN)
            except curses.error:
                pass
            line += 1

        # Draw button
        line += 2
        self.draw_button(line, 2, "Start Installation", True, self.colors.GREEN)

        self.draw_footer("Click button or press Enter to continue | q: Quit")

        return line

    def screen_profiles(self):
        """Profile selection screen"""
        self.current_screen = 'profiles'
        self.clear_screen()

        line = self.draw_header("Select Installation Profile")
        line += 1

        # Instructions
        try:
            self.stdscr.addstr(line, 2, "Choose a profile to get started:", self.colors.CYAN)
        except curses.error:
            pass
        line += 2

        # Profile list
        profile_list = list(PROFILES.keys())
        profiles_with_custom = profile_list + ['custom']

        for idx, profile_key in enumerate(profiles_with_custom):
            if profile_key == 'custom':
                name = "Custom"
                desc = "Choose specific tools manually"
                color = self.colors.YELLOW
            else:
                profile = PROFILES[profile_key]
                name = profile['name']
                desc = profile['description']
                color = self.colors.CYAN

            # Draw profile
            button_y = line + idx * 2
            try:
                self.stdscr.addstr(button_y, 4, f"{name}", color | self.colors.BOLD)
                self.stdscr.addstr(button_y + 1, 6, f"{desc}", self.colors.GREEN)
            except curses.error:
                pass

        # Draw buttons
        button_line = button_y + 3
        for idx, profile_key in enumerate(profiles_with_custom):
            x = 4 + idx * 20
            if x < 70:  # Don't overflow
                self.draw_button(button_line, x, str(idx + 1), idx == 0)

        self.draw_footer("Click profile or press number to select | q: Quit")

        return {
            'screen': 'profiles',
            'profiles': profiles_with_custom,
            'button_line': button_line
        }

    def screen_categories(self):
        """Category selection screen"""
        self.current_screen = 'categories'
        self.clear_screen()

        line = self.draw_header("Select Tools by Category")
        line += 1

        try:
            self.stdscr.addstr(line, 2, "Select categories to configure tools:", self.colors.CYAN)
        except curses.error:
            pass
        line += 2

        # Store button positions for mouse clicks
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
                color = self.colors.GREEN
            elif selected > 0:
                status = f"[{selected}/{total}]"
                color = self.colors.YELLOW
            else:
                status = f"[None]"
                color = self.colors.CYAN

            try:
                self.stdscr.addstr(cat_y, 4, desc, self.colors.CYAN | self.colors.BOLD)
                self.stdscr.addstr(cat_y, 30, status, color | self.colors.BOLD)
            except curses.error:
                pass

            # Store button position
            self.category_buttons.append({
                'category': category,
                'y': cat_y,
                'x': 4,
                'width': len(desc)
            })

        # Draw action buttons
        button_y = cat_y + 2
        self.draw_button(button_y, 4, "Accept", True, self.colors.GREEN)
        self.draw_button(button_y, 20, "Back")

        self.draw_footer("Click category to edit | Click Accept when done | q: Quit")

        return {
            'screen': 'categories',
            'button_y': button_y
        }

    def screen_tools(self, category: str):
        """Tool selection within a category"""
        self.current_screen = 'tools'
        self.clear_screen()

        desc = CATEGORIES[category]['description']
        tools = CATEGORIES[category]['tools']

        line = self.draw_header(desc)
        line += 1

        try:
            self.stdscr.addstr(line, 2, "Toggle tools to select/deselect:", self.colors.CYAN)
        except curses.error:
            pass
        line += 2

        # Store tool button positions
        self.tool_buttons = []

        # Two columns
        col_width = 35
        for idx, tool in enumerate(tools):
            col = idx // 10
            row = idx % 10
            y = line + row
            x = 4 + col * col_width

            is_selected = tool in self.tool_selections[category]
            status = "[✓]" if is_selected else "[ ]"
            color = self.colors.GREEN if is_selected else self.colors.CYAN

            try:
                self.stdscr.addstr(y, x, status, color | self.colors.BOLD)
                self.stdscr.addstr(y, x + 5, tool, self.colors.GREEN)
            except curses.error:
                pass

            # Store button position
            self.tool_buttons.append({
                'tool': tool,
                'y': y,
                'x': x,
                'width': len(tool) + 5
            })

        # Draw action buttons
        button_y = y + 2
        self.draw_button(button_y, 4, "Select All")
        self.draw_button(button_y, 20, "Select None")
        self.draw_button(button_y, 40, "Done", True, self.colors.GREEN)

        self.draw_footer("Click tool to toggle | Click Done when finished | q: Quit")

        return {
            'screen': 'tools',
            'category': category,
            'button_y': button_y
        }

    def screen_confirm(self):
        """Confirmation screen"""
        self.current_screen = 'confirm'
        self.clear_screen()

        line = self.draw_header("Confirm Installation")
        line += 1

        try:
            self.stdscr.addstr(line, 2, "Summary of selections:", self.colors.CYAN | self.colors.BOLD)
        except curses.error:
            pass
        line += 1
        try:
            self.stdscr.addstr(line, 2, f"Total tools: {len(self.selected_tools)}", self.colors.GREEN | self.colors.BOLD)
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

        # Display selections
        for category in sorted(tools_by_category.keys()):
            cat_desc = CATEGORIES[category]['description']
            tools = sorted(tools_by_category[category])

            try:
                self.stdscr.addstr(line, 2, f"{cat_desc}:", self.colors.CYAN | self.colors.BOLD)
            except curses.error:
                pass
            line += 1

            tool_line = ", ".join(tools)
            try:
                self.stdscr.addstr(line, 4, tool_line, self.colors.GREEN)
            except curses.error:
                pass
            line += 2

        # Draw buttons
        self.draw_button(line, 4, "Install", True, self.colors.GREEN)
        self.draw_button(line, 20, "Cancel")

        self.draw_footer("Click Install to proceed or Cancel to abort | q: Quit")

        return {
            'screen': 'confirm',
            'button_y': line
        }

    def handle_mouse(self, event, screen_data):
        """Handle mouse events"""
        if event:
            mouse_y, mouse_x = event.y, event.x
            bstate = event.bstate

            # Check for left click
            if bstate & curses.BUTTON1_CLICKED or bstate & curses.BUTTON1_DOUBLE_CLICKED:
                # Welcome screen
                if self.current_screen == 'welcome':
                    # Check for "Start Installation" button
                    if mouse_y == screen_data.get('button_line', 0) + 2 and 2 <= mouse_x <= 22:
                        return 'next'

                # Profiles screen
                elif self.current_screen == 'profiles':
                    profiles = screen_data.get('profiles', [])
                    # Check profile buttons
                    button_line = screen_data.get('button_line', 0)
                    for idx, profile in enumerate(profiles):
                        x = 4 + idx * 20
                        if x <= mouse_x <= x + 15 and mouse_y == button_line:
                            return f'profile_{profile}'

                # Categories screen
                elif self.current_screen == 'categories':
                    # Check category buttons
                    for btn in self.category_buttons:
                        if (btn['y'] == mouse_y and
                            btn['x'] <= mouse_x <= btn['x'] + btn['width']):
                            return f'category_{btn["category"]}'

                    # Check Accept button
                    button_y = screen_data.get('button_y', 0)
                    if mouse_y == button_y:
                        if 4 <= mouse_x <= 13:  # Accept button
                            return 'accept'
                        elif 20 <= mouse_x <= 28:  # Back button
                            return 'back'

                # Tools screen
                elif self.current_screen == 'tools':
                    category = screen_data.get('category', '')
                    # Check tool buttons
                    for btn in self.tool_buttons:
                        if (btn['y'] == mouse_y and
                            btn['x'] <= mouse_x <= btn['x'] + btn['width']):
                            return f'toggle_{btn["tool"]}'

                    # Check action buttons
                    button_y = screen_data.get('button_y', 0)
                    if mouse_y == button_y:
                        if 4 <= mouse_x <= 16:  # Select All
                            return 'select_all'
                        elif 20 <= mouse_x <= 34:  # Select None
                            return 'select_none'
                        elif 40 <= mouse_x <= 47:  # Done
                            return 'done'

                # Confirm screen
                elif self.current_screen == 'confirm':
                    button_y = screen_data.get('button_y', 0)
                    if mouse_y == button_y:
                        if 4 <= mouse_x <= 14:  # Install button
                            return 'install'
                        elif 20 <= mouse_x <= 30:  # Cancel button
                            return 'cancel'

        return None

    def run(self):
        """Main TUI loop"""
        selected_profile = None
        screen_data = self.screen_welcome()

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

            # Wait for input
            event = self.stdscr.getch()

            action = None

            # Handle mouse events
            if event == curses.KEY_MOUSE:
                try:
                    _, mx, my, _, bstate = curses.getmouse()
                    mouse_event = type('obj', (object,), {'y': my, 'x': mx, 'bstate': bstate})
                    action = self.handle_mouse(mouse_event, screen_data)
                except curses.error:
                    pass

            # Handle keyboard events
            elif event == ord('q') or event == ord('Q'):
                # Quit
                return None

            elif event == curses.KEY_ENTER or event == 10 or event == 13:
                # Enter key
                if self.current_screen == 'welcome':
                    action = 'next'
                elif self.current_screen == 'categories':
                    action = 'accept'
                elif self.current_screen == 'tools':
                    action = 'done'
                elif self.current_screen == 'confirm':
                    action = 'install'

            elif event == curses.KEY_UP or event == ord('k'):
                # Navigate up (simplified)
                pass

            elif event == curses.KEY_DOWN or event == ord('j'):
                # Navigate down (simplified)
                pass

            # Handle actions
            if action == 'next' or action == 'profile_1':
                selected_profile = 'minimal'
                self.selected_tools = get_tools_from_profile(selected_profile)
                screen_data = self.screen_categories()

            elif action == 'back' or action == 'profile_6':
                selected_profile = None
                self.selected_tools = set()
                screen_data = self.screen_profiles()

            elif action.startswith('profile_'):
                profile_key = action.split('_', 1)[1]
                if profile_key != 'custom':
                    selected_profile = profile_key
                    self.selected_tools = get_tools_from_profile(profile_key)
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
                else:
                    pass  # Must select at least one tool

            elif action == 'install':
                return self.selected_tools

            elif action == 'cancel':
                self.selected_tools = set()
                screen_data = self.screen_categories()

def main(stdscr):
    """Main entry point for TUI"""
    installer = TUIInstaller(stdscr)
    selected_tools = installer.run()

    # Clean up curses
    curses.endwin()

    if selected_tools:
        # Perform installation
        current_os = detect_os()
        repo_root = Path(__file__).parent.parent.parent

        print(f"\n{curses.TERM}Installing {len(selected_tools)} tools...\n")

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

if __name__ == '__main__':
    try:
        curses.wrapper(main)
    except KeyboardInterrupt:
        print("\n\nInstallation interrupted by user.")
        sys.exit(130)
    except Exception as e:
        print(f"\nUnexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
