#!/bin/sh
# Local linting script for shell scripts
# POSIX-compliant

set -e -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

printf "%bRunning ShellCheck on all shell scripts...%b\n" "$YELLOW" "$NC"

# Check if shellcheck is installed
if ! command -v shellcheck >/dev/null 2>&1; then
    printf "%bERROR: shellcheck is not installed%b\n" "$RED" "$NC"
    printf "\nTo install shellcheck:\n"
    printf "  macOS:   brew install shellcheck\n"
    printf "  Ubuntu:  sudo apt install shellcheck\n"
    printf "  Fedora:  sudo dnf install shellcheck\n"
    printf "  Arch:    sudo pacman -S shellcheck\n"
    printf "\nOr visit: https://www.shellcheck.net/\n"
    exit 1
fi

# Display shellcheck version
printf "ShellCheck version: "
shellcheck --version | head -1
printf "\n"

# Run shellcheck on all .sh files
failed=0
total=0

for script in $(find . -type f -name "*.sh"); do
    total=$((total + 1))
    printf "Checking: %s" "$script"

    if shellcheck "$script" >/dev/null 2>&1; then
        printf " %b✓%b\n" "$GREEN" "$NC"
    else
        printf " %b✗ FAILED%b\n" "$RED" "$NC"
        shellcheck "$script"
        failed=$((failed + 1))
    fi
done

printf "\n"
printf "====================\n"
printf "Total files: %d\n" "$total"
printf "Passed: %b%d%b\n" "$GREEN" "$((total - failed))" "$NC"
printf "Failed: %b%d%b\n" "$RED" "$failed" "$NC"
printf "====================\n"

if [ "$failed" -gt 0 ]; then
    printf "\n%bLinting FAILED!%b\n" "$RED" "$NC"
    printf "Please fix the shellcheck warnings above.\n"
    exit 1
else
    printf "\n%b✓ All scripts passed linting!%b\n" "$GREEN" "$NC"
    exit 0
fi
