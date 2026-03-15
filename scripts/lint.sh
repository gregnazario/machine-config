#!/bin/sh
# Local linting and formatting script for shell scripts
# POSIX-compliant

set -e -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if shfmt is installed
if ! command -v shfmt >/dev/null 2>&1; then
	printf "%bWARNING: shfmt is not installed%b\n" "$YELLOW" "$NC"
	printf "\nTo install shfmt:\n"
	printf "  macOS:   brew install shfmt\n"
	printf "  Ubuntu:  go install mvdan.cc/sh/v3/cmd/shfmt@latest\n"
	printf "  Fedora:  sudo dnf install shfmt\n"
	printf "  Arch:    sudo pacman -S shfmt\n"
	printf "\nOr visit: https://github.com/mvdan/sh\n"
	printf "\nSkipping shfmt checks...\n\n"
	SHFMT_AVAILABLE=0
else
	SHFMT_AVAILABLE=1
	printf "%bRunning shfmt formatting check...%b\n" "$YELLOW" "$NC"
	printf "shfmt version: "
	shfmt --version
	printf "\n"
fi

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

printf "%bRunning ShellCheck on all shell scripts...%b\n" "$YELLOW" "$NC"

# Display shellcheck version
printf "ShellCheck version: "
shellcheck --version | head -1
printf "\n"

# Run shfmt check if available
if [ "$SHFMT_AVAILABLE" -eq 1 ]; then
	# Check if any files need formatting
	if shfmt -d . >/dev/null 2>&1; then
		printf "%b✓ All scripts are properly formatted%b\n" "$GREEN" "$NC"
	else
		printf "\n%b✗ Some scripts are not properly formatted%b\n" "$RED" "$NC"
		printf "\nRun: shfmt -w .  (to fix formatting)\n"
		printf "\nDiff:\n"
		shfmt -d .
		exit 1
	fi
	printf "\n"
fi

# Collect results in a temporary file to avoid subshell issues
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

# Check each script and write result
# shellcheck disable=SC2044
find scripts/ -type f -name "*.sh" 2>/dev/null | while IFS= read -r script; do
	if [ -n "$script" ]; then
		if shellcheck "$script" >/dev/null 2>&1; then
			printf "%s: PASS\n" "$script" >>"$tmpfile"
		else
			printf "%s: FAIL\n" "$script" >>"$tmpfile"
		fi
	fi
done

# Read results and display
failed=0
total=0
while IFS= read -r line; do
	total=$((total + 1))
	script_name=$(printf "%s" "$line" | cut -d: -f1)
	result=$(printf "%s" "$line" | cut -d: -f2 | tr -d ' ')

	if [ "$result" = "PASS" ]; then
		printf "Checking: %s %b✓%b\n" "$script_name" "$GREEN" "$NC"
	else
		printf "Checking: %s %b✗ FAILED%b\n" "$script_name" "$RED" "$NC"
		shellcheck "$(printf "%s" "$line" | cut -d: -f1)"
		failed=$((failed + 1))
	fi
done <"$tmpfile"

printf "\n"
printf "====================\n"
printf "Total files: %d\n" "$total"
if [ "$total" -gt 0 ]; then
	passed=$((total - failed))
	printf "Passed: %b%d%b\n" "$GREEN" "$passed" "$NC"
fi
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
