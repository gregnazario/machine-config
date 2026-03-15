# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-15

### Added
- Versioning system with VERSION file
- Version display in TUI and CLI modes
- `--version` flag for checking version
- Comprehensive test suite for TUI installer (tests/test_tui.py)
- GitHub Actions CI/CD workflow for automated testing
- Critical installation bug fix for long package definitions

### Fixed
- **Critical**: Package definition lines were too long (329 characters), causing "Filename too long" errors
- Broke up all package definitions using shell variable continuation to ensure compatibility across shell implementations
- Installation was completely failing on all categories before this fix

### Technical
- Tests cover TUI initialization, navigation logic, input handling, screen rendering, and regression tests
- CI/CD tests on Python 3.9, 3.10, 3.11, and 3.12
- Version integrated into header, system info, and TUI welcome screen

## [Unreleased]

### Planned
- Fix curses mocking in test suite
- Remove non-TUI version once tests are fully passing
- Add version comparison/checking for updates
