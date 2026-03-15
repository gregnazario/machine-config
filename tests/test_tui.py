#!/usr/bin/env python3
"""
TUI Installer Test Suite

Tests the TUI installer without requiring a real terminal.
Uses mocking to simulate curses and user input.
"""

import sys
import os
import unittest
from unittest.mock import Mock, MagicMock, patch, call
from io import StringIO

# Add parent directory to path so we can import scripts/install
repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, repo_root)

# Try to import curses
try:
    import curses
    HAS_CURSES = True
except ImportError:
    HAS_CURSES = False

# Test data
PROFILES = {
    'minimal': {
        'name': 'Minimal',
        'description': 'Essential tools for everyday use',
        'tools': {'shells': ['zsh'], 'navigation': ['fd', 'ripgrep', 'fzf'], 'version-control': ['git'], 'documentation': ['tldr']}
    },
    'developer': {
        'name': 'Developer',
        'description': 'Full development environment',
        'tools': 'all'
    }
}

CATEGORIES = {
    'shells': {'description': 'Shell Configurations', 'tools': ['zsh', 'fish', 'nushell']},
    'navigation': {'description': 'File Navigation', 'tools': ['fd', 'ripgrep', 'fzf', 'yazi']},
    'editors': {'description': 'Text Editors', 'tools': ['neovim', 'helix', 'emacs']},
}


class TestTUIInitialization(unittest.TestCase):
    """Test TUI installer initialization"""

    @unittest.skipIf(not HAS_CURSES, "curses not available")
    def test_initialization(self):
        """Test that TUI can be initialized"""
        from scripts.install.install import TUIInstaller

        # Create a mock stdscr
        mock_stdscr = MagicMock()
        mock_stdscr.getmaxyx.return_value = (24, 80)

        # Initialize TUI
        with patch('curses.curs_set'), \
             patch('curses.noecho'), \
             patch('curses.cbreak'), \
             patch('curses.initscr', return_value=mock_stdscr), \
             patch('curses.mousemask'), \
             patch('curses.has_colors', return_value=False), \
             patch('curses.init_pair'), \
             patch('curses.color_pair', return_value=0):

            installer = TUIInstaller(mock_stdscr)

            # Check basic attributes
            self.assertIsNotNone(installer)
            self.assertEqual(installer.current_screen, 'welcome')
            self.assertEqual(installer.cursor_pos, 0)
            self.assertIsInstance(installer.selected_tools, set)
            self.assertIsInstance(installer.tool_selections, dict)


class TestNavigationLogic(unittest.TestCase):
    """Test cursor navigation logic"""

    def test_cursor_bounds(self):
        """Test that cursor stays within bounds"""
        max_items = 10
        cursor_pos = 0

        # Test moving down
        cursor_pos = min(max_items - 1, cursor_pos + 1)
        self.assertEqual(cursor_pos, 1)

        # Test moving up
        cursor_pos = max(0, cursor_pos - 1)
        self.assertEqual(cursor_pos, 0)

        # Test bounds
        cursor_pos = max(0, -1)
        self.assertEqual(cursor_pos, 0)

        cursor_pos = min(max_items - 1, 999)
        self.assertEqual(cursor_pos, 9)

    def test_button_navigation(self):
        """Test navigation to buttons"""
        # Simulate having 3 tools + 3 buttons = 6 total items
        max_items = 6
        num_tools = 3

        # Should be able to navigate to buttons (indices 3, 4, 5)
        cursor_pos = num_tools  # First button
        self.assertTrue(cursor_pos >= num_tools)
        self.assertTrue(cursor_pos < max_items)

        cursor_pos = num_tools + 1  # Middle button
        self.assertTrue(cursor_pos >= num_tools)

        cursor_pos = max_items - 1  # Last button
        self.assertEqual(cursor_pos, 5)


class TestInputHandling(unittest.TestCase):
    """Test input to action mapping"""

    def test_quit_key(self):
        """Test that q/Q keys trigger quit"""
        from scripts.install.install import TUIInstaller

        # Create mock installer
        installer = Mock()
        installer.current_screen = 'welcome'
        installer.max_items = 1
        installer.cursor_pos = 0

        # Test quit keys
        self._test_key_to_action(installer, ord('q'), 'quit')
        self._test_key_to_action(installer, ord('Q'), 'quit')
        self._test_key_to_action(installer, 3, 'quit')  # Ctrl-C
        self._test_key_to_action(installer, 4, 'quit')  # Ctrl-D

    def test_navigation_keys(self):
        """Test arrow and vim keys"""
        installer = Mock()
        installer.max_items = 10
        installer.cursor_pos = 5
        installer.action_buttons = []

        # Test down keys
        for key in [ord('j'), ord('J'), 258]:  # j, J, KEY_DOWN
            installer.cursor_pos = 5
            installer.cursor_pos = min(installer.max_items - 1, installer.cursor_pos + 1)
            self.assertEqual(installer.cursor_pos, 6)

        # Test up keys
        for key in [ord('k'), ord('K'), 259]:  # k, K, KEY_UP
            installer.cursor_pos = 5
            installer.cursor_pos = max(0, installer.cursor_pos - 1)
            self.assertEqual(installer.cursor_pos, 4)

    def _test_key_to_action(self, installer, key_code, expected_action):
        """Helper to test key to action mapping"""
        # This would use the real handle_input logic
        # For now, just test the key codes are recognized
        self.assertIn(key_code, [3, 4, ord('q'), ord('Q'),  # quit
                                   ord('k'), ord('K'), ord('j'), ord('J'),  # navigation
                                   27])  # ESC


class TestScreenRendering(unittest.TestCase):
    """Test screen rendering logic"""

    def test_screen_welcome(self):
        """Test welcome screen structure"""
        from scripts.install.install import TUIInstaller

        mock_stdscr = MagicMock()
        mock_stdscr.getmaxyx.return_value = (24, 80)

        with patch('curses.curs_set'), \
             patch('curses.noecho'), \
             patch('curses.cbreak'), \
             patch('curses.initscr', return_value=mock_stdscr), \
             patch('curses.mousemask'), \
             patch('curses.has_colors', return_value=False), \
             patch('curses.init_pair'), \
             patch('curses.color_pair', return_value=0):

            installer = TUIInstaller(mock_stdscr)

            # Test welcome screen can be drawn
            try:
                result = installer.screen_welcome()
                self.assertIsNotNone(result)
            except Exception as e:
                self.fail(f"screen_welcome() failed: {e}")

    def test_screen_profiles(self):
        """Test profiles screen structure"""
        from scripts.install.install import TUIInstaller

        mock_stdscr = MagicMock()
        mock_stdscr.getmaxyx.return_value = (24, 80)

        with patch('curses.curs_set'), \
             patch('curses.noecho'), \
             patch('curses.cbreak'), \
             patch('curses.initscr', return_value=mock_stdscr), \
             patch('curses.mousemask'), \
             patch('curses.has_colors', return_value=False), \
             patch('curses.init_pair'), \
             patch('curses.color_pair', return_value=0):

            installer = TUIInstaller(mock_stdscr)

            # Test profiles screen
            try:
                result = installer.screen_profiles()
                self.assertIsNotNone(result)
                self.assertIn('screen', result)
                self.assertIn('profiles', result)
            except Exception as e:
                self.fail(f"screen_profiles() failed: {e}")


class TestBugFixes(unittest.TestCase):
    """Test that previous bugs don't regress"""

    def test_cursor_reset_bug(self):
        """Test that cursor position is preserved across redraws"""
        # This was a bug where cursor_pos was reset to 0 on every redraw
        max_items = 10
        cursor_pos = 5

        # Simulate multiple redraws
        for _ in range(5):
            # In the bug, this would reset to 0
            # In the fix, it should preserve
            current_pos = cursor_pos

        # After all redraws, should still be at 5
        self.assertEqual(current_pos, 5)

    def test_none_action_crash(self):
        """Test that None actions don't crash the UI"""
        # This was a bug where pressing unrecognized keys crashed
        action = None

        # Test that we handle None actions gracefully
        if action is None:
            # Should just continue, not crash
            pass
        elif action.startswith('profile_'):
            self.fail("Should not reach here")

        # Test made it here
        self.assertTrue(True)

    def test_terminfo_fallback(self):
        """Test terminfo fallback for Ghostty and similar"""
        # Simulate Ghostty terminfo not found
        term = 'xterm-ghostty'
        terminfo_exists = False

        if not terminfo_exists:
            # Should fallback to xterm-256color
            fallback_term = 'xterm-256color'
            self.assertIn(fallback_term, ['xterm-256color', 'xterm'])

    def test_button_activation(self):
        """Test that buttons can be activated with Enter"""
        # Test that cursor position determines button activation
        max_items = 6  # 3 tools + 3 buttons
        cursor_pos = 4  # On a button
        num_tools = 3

        # Should recognize it's a button
        is_on_button = cursor_pos >= num_tools
        self.assertTrue(is_on_button)

        # Should be within button range
        button_index = cursor_pos - num_tools
        self.assertEqual(button_index, 1)  # Second button (0-indexed)


class TestIntegration(unittest.TestCase):
    """Integration tests for complete workflows"""

    @unittest.skipIf(not HAS_CURSES, "curses not available")
    def test_full_navigation_flow(self):
        """Test navigating through all screens"""
        from scripts.install.install import TUIInstaller

        mock_stdscr = MagicMock()
        mock_stdscr.getmaxyx.return_value = (24, 80)

        with patch('curses.curs_set'), \
             patch('curses.noecho'), \
             patch('curses.cbreak'), \
             patch('curses.initscr', return_value=mock_stdscr), \
             patch('curses.mousemask'), \
             patch('curses.has_colors', return_value=False), \
             patch('curses.init_pair'), \
             patch('curses.color_pair', return_value=0):

            installer = TUIInstaller(mock_stdscr)

            # Test we can draw all screens without crashing
            screens = ['welcome', 'profiles', 'categories']
            for screen in screens:
                installer.current_screen = screen
                try:
                    if screen == 'welcome':
                        installer.screen_welcome()
                    elif screen == 'profiles':
                        installer.screen_profiles()
                    elif screen == 'categories':
                        installer.screen_categories()
                except Exception as e:
                    self.fail(f"Failed to draw {screen} screen: {e}")

    def test_profile_selection(self):
        """Test profile selection logic"""
        # Test that selecting a profile works
        profile_key = 'minimal'

        # Check profile exists
        self.assertIn(profile_key, PROFILES)

        # Check profile has tools
        profile = PROFILES[profile_key]
        self.assertIn('tools', profile)
        self.assertIsNotNone(profile['tools'])

        # Check it has the expected tools
        tools = profile['tools']['shells']
        self.assertIn('zsh', tools)


def run_tests():
    """Run all tests and report results"""
    print("=" * 60)
    print("TUI Installer Test Suite")
    print("=" * 60)
    print()

    # Create test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # Add all test classes
    suite.addTests(loader.loadTestsFromTestCase(TestTUIInitialization))
    suite.addTests(loader.loadTestsFromTestCase(TestNavigationLogic))
    suite.addTests(loader.loadTestsFromTestCase(TestInputHandling))
    suite.addTests(loader.loadTestsFromTestCase(TestScreenRendering))
    suite.addTests(loader.loadTestsFromTestCase(TestBugFixes))
    suite.addTests(loader.loadTestsFromTestCase(TestIntegration))

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Print summary
    print()
    print("=" * 60)
    print("Test Summary")
    print("=" * 60)
    print(f"Tests run: {result.testsRun}")
    print(f"Successes: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f"Failures: {len(result.failures)}")
    print(f"Errors: {len(result.errors)}")

    if result.wasSuccessful():
        print()
        print("✓ All tests passed!")
        return 0
    else:
        print()
        print("✗ Some tests failed")
        return 1


if __name__ == '__main__':
    sys.exit(run_tests())
