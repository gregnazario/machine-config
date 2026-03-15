#!/bin/sh
# Interactive installer for Greg's Dotfiles
# Detects OS and lets user choose which tools to configure
# POSIX-compliant shell script

set -e -u

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
# shellcheck source=../utils/detect-os.sh
# shellcheck disable=SC1091
if [ -f "$SCRIPT_DIR/../utils/detect-os.sh" ]; then
	. "$SCRIPT_DIR/../utils/detect-os.sh"
fi

# shellcheck source=../utils/common.sh
# shellcheck disable=SC1091
if [ -f "$SCRIPT_DIR/../utils/common.sh" ]; then
	. "$SCRIPT_DIR/../utils/common.sh"
fi

# Header
print_header() {
	clear
	printf "%b╔════════════════════════════════════════════════════════════╗%b\n" "$CYAN" "$NC"
	printf "%b║%b        %bGreg's Dotfiles - Interactive Installer%b           %b║%b\n" "$CYAN" "$NC" "$GREEN" "$NC" "$CYAN" "$NC"
	printf "%b╚════════════════════════════════════════════════════════════╝%b\n" "$CYAN" "$NC"
	printf "\n"
}

# Detect OS (fallback if detect-os.sh not available)
detect_os_fallback() {
	if [ "$(uname)" = "Darwin" ]; then
		printf "macos"
	elif [ -f /etc/fedora-release ]; then
		printf "fedora"
	elif [ -f /etc/arch-release ]; then
		printf "arch"
	elif [ -f /etc/gentoo-release ]; then
		printf "gentoo"
	elif [ -f /etc/ubuntu-release ] || grep -q Ubuntu /etc/os-release 2>/dev/null; then
		printf "ubuntu"
	elif [ -f /etc/void-release ]; then
		printf "void"
	elif [ -f /etc/oracle-release ]; then
		printf "oracle"
	elif [ -f /etc/rocky-release ]; then
		printf "rocky"
	elif [ -f /etc/alpine-release ]; then
		printf "alpine"
	elif grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
		printf "rpi"
	elif [ "$(uname)" = "Linux" ] && grep -q microsoft /proc/version 2>/dev/null; then
		printf "windows"
	elif [ "$(uname)" = "FreeBSD" ]; then
		printf "freebsd"
	else
		printf "unknown"
	fi
}

# Get current OS
CURRENT_OS=$(detect_os_fallback)

# Print system info
print_system_info() {
	printf "%bSystem Information:%b\n" "$BLUE" "$NC"
	printf "  OS:        %b%s%b\n" "$GREEN" "$(capitalize "$CURRENT_OS")" "$NC"
	printf "  Hostname:  %b%s%b\n" "$GREEN" "$(hostname)" "$NC"
	printf "  User:      %b%s%b\n" "$GREEN" "$(whoami)" "$NC"
	printf "\n"
}

# Capitalize first letter
capitalize() {
	# Use sed to capitalize first letter
	printf "%s" "$1" | sed 's/./\U&/'
}

# Print section header
print_section() {
	printf "\n"
	printf "%b═══════════════════════════════════════════════════════════%b\n" "$PURPLE" "$NC"
	printf "%b  %s%b\n" "$PURPLE" "$1" "$NC"
	printf "%b═══════════════════════════════════════════════════════════%b\n" "$PURPLE" "$NC"
	printf "\n"
}

# Prompt yes/no
prompt_yes_no() {
	prompt="$1"
	default="${2:-n}"

	if [ "$default" = "y" ]; then
		prompt_printf="$prompt [Y/n] "
	else
		prompt_printf="$prompt [y/N] "
	fi

	while true; do
		printf "%b→%b %s" "$YELLOW" "$NC" "$prompt_printf"
		read -r response
		response=${response:-$default}

		case "$response" in
		[Yy] | [Yy][Ee][Ss])
			return 0
			;;
		[Nn] | [Nn][Oo])
			return 1
			;;
		*)
			printf "%bPlease answer yes or no.%b\n" "$RED" "$NC"
			;;
		esac
	done
}

# Select from options
prompt_select() {
	prompt="$1"
	shift
	options="$*"

	printf "%b→%b %s\n" "$YELLOW" "$NC" "$prompt"
	printf "\n"

	# Count options and display
	i=1
	for opt in $options; do
		printf "  %b%s)%b %s\n" "$CYAN" "$i" "$NC" "$opt"
		i=$((i + 1))
	done
	printf "\n"

	# Get total count
	count=0
	for _ in $options; do
		count=$((count + 1))
	done

	while true; do
		printf "%b→%b Choice [1-%s] [1]: " "$YELLOW" "$NC" "$count"
		read -r choice
		choice=${choice:-1}

		# Validate choice is a number
		case "$choice" in
		'' | *[!0-9]*)
			printf "%bInvalid choice. Please enter a number.%b\n" "$RED" "$NC"
			continue
			;;
		esac

		if [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
			# Get the selected option
			i=1
			for opt in $options; do
				if [ "$i" -eq "$choice" ]; then
					printf "%s\n" "$opt"
					return
				fi
				i=$((i + 1))
			done
		else
			printf "%bInvalid choice. Please enter a number between 1 and %s.%b\n" "$RED" "$count" "$NC"
		fi
	done
}

# Multi-select from options
prompt_multi_select() {
	prompt="$1"
	shift
	options="$*"

	printf "%b→%b %s\n" "$YELLOW" "$NC" "$prompt"
	printf "  %bEnter numbers separated by spaces (e.g., '1 3 5')%b\n" "$CYAN" "$NC"
	printf "\n"

	# Display options
	i=1
	for opt in $options; do
		printf "  %b%s)%b %s\n" "$CYAN" "$i" "$NC" "$opt"
		i=$((i + 1))
	done
	printf "\n"

	# Get total count
	count=0
	for _ in $options; do
		count=$((count + 1))
	done

	# Get selection
	printf "%b→%b Selection [1-%s] (all): " "$YELLOW" "$NC" "$count"
	read -r selection
	selection=${selection:-$(seq -s " " 1 "$count")}

	# Process selection
	selected=""
	for num in $selection; do
		# Validate num is numeric
		case "$num" in
		'' | *[!0-9]*)
			continue
			;;
		esac

		if [ "$num" -ge 1 ] && [ "$num" -le "$count" ]; then
			i=1
			for opt in $options; do
				if [ "$i" -eq "$num" ]; then
					if [ -n "$selected" ]; then
						selected="$selected $opt"
					else
						selected="$opt"
					fi
					break
				fi
				i=$((i + 1))
			done
		fi
	done

	printf "%s\n" "$selected"
}

# Display welcome message
welcome() {
	print_header
	print_system_info

	printf "%bWelcome to the interactive dotfiles installer!%b\n" "$GREEN" "$NC"
	printf "\n"
	printf "This installer will help you:\n"
	printf "  • Select which tools to configure\n"
	printf "  • Install tools (optional)\n"
	printf "  • Apply OS-specific configuration layers\n"
	printf "  • Create symlinks to your home directory\n"
	printf "\n"
	printf "%bPress Enter to continue...%b\n" "$YELLOW" "$NC"
	# Read but don't use the variable
	# shellcheck disable=SC3061
	read -r _dummy
}

# Define categories
get_categories() {
	printf "terminals editors shells navigation monitoring version-control network productivity transfer development containers security archive documentation fun"
}

# Get category description
get_category_description() {
	category="$1"
	case "$category" in
	terminals)
		printf "Terminal Multiplexers (zellij, tmux, screen)"
		;;
	editors)
		printf "Text Editors (neovim, helix, emacs)"
		;;
	shells)
		printf "Shell Configurations (zsh, fish, nushell)"
		;;
	navigation)
		printf "File Navigation (yazi, fd, ripgrep, fzf)"
		;;
	monitoring)
		printf "System Monitoring (btop, glances, modern-utils)"
		;;
	version-control)
		printf "Version Control (git, gh, lazygit, git-fuzzy)"
		;;
	network)
		printf "Network Tools (gping, httpie, speedtest, bandwhich)"
		;;
	productivity)
		printf "Productivity Tools (presenterm, todotxt, jira-cli)"
		;;
	transfer)
		printf "Download/Transfer (aria2, curlie, wget2)"
		;;
	development)
		printf "Dev Tools (python, rust, nodejs, project-templates)"
		;;
	containers)
		printf "Container Tools (nix, docker, kubernetes, version-managers)"
		;;
	security)
		printf "Security Tools (age, ssh, 1password-cli, totp)"
		;;
	archive)
		printf "Archive Tools (7z, unar, compressors, parallel)"
		;;
	documentation)
		printf "Documentation (tldr, tealdeer, man, cheat)"
		;;
	fun)
		printf "Fun Utilities (fetch, qalc, joke)"
		;;
	*)
		printf "Unknown category"
		;;
	esac
}

# Get tools for a category
get_category_tools() {
	category="$1"
	case "$category" in
	terminals)
		printf "zellij tmux screen"
		;;
	editors)
		printf "neovim helix emacs"
		;;
	shells)
		printf "zsh fish nushell"
		;;
	navigation)
		printf "yazi fd ripgrep fzf"
		;;
	monitoring)
		printf "btop glances modern-utils"
		;;
	version-control)
		printf "git gh lazygit git-fuzzy"
		;;
	network)
		printf "gping httpie speedtest bandwhich"
		;;
	productivity)
		printf "presenterm todotxt jira-cli terminal-notes"
		;;
	transfer)
		printf "aria2 curlie wget2"
		;;
	development)
		printf "python rust nodejs project-templates"
		;;
	containers)
		printf "nix docker kubernetes version-managers"
		;;
	security)
		printf "age ssh 1password-cli totp"
		;;
	archive)
		printf "compressors parallel unar image-tools"
		;;
	documentation)
		printf "tldr tealdeer man cheat docuum"
		;;
	fun)
		printf "fetch utilities qalc"
		;;
	*)
		printf ""
		;;
	esac
}

# Select categories
select_categories() {
	print_section "Step 1: Select Categories"

	printf "Select which categories of tools you want to configure:\n"
	printf "\n"

	categories=$(get_categories)
	i=1
	for cat in $categories; do
		desc=$(get_category_description "$cat")
		printf "  %b%s)%b %s\n" "$CYAN" "$i" "$NC" "$desc"
		i=$((i + 1))
	done
	printf "  %ba)%b All categories\n" "$CYAN" "$NC"
	printf "\n"

	# Get count
	count=0
	for _ in $categories; do
		count=$((count + 1))
	done

	printf "%b→%b Selection [1-%s or 'a' for all]: " "$YELLOW" "$NC" "$count"
	read -r selection

	case "$selection" in
	[Aa] | [Aa][Ll][Ll])
		# All categories
		printf "%s\n" "$categories"
		;;
	*)
		# Parse selection
		selected=""
		for num in $selection; do
			case "$num" in
			'' | *[!0-9]*)
				continue
				;;
			esac

			if [ "$num" -ge 1 ] && [ "$num" -le "$count" ]; then
				i=1
				for cat in $categories; do
					if [ "$i" -eq "$num" ]; then
						if [ -n "$selected" ]; then
							selected="$selected $cat"
						else
							selected="$cat"
						fi
						break
					fi
					i=$((i + 1))
				done
			fi
		done
		printf "%s\n" "$selected"
		;;
	esac
}

# Confirm installation
confirm_install() {
	print_section "Step 2: Confirm Installation"

	printf "Summary of selections:\n"
	printf "\n"

	# Display summary
	# shellcheck disable=SC2086
	for category; do
		printf "%b%s:%b\n" "$CYAN" "$category" "$NC"
		tools=$(get_category_tools "$category")
		for tool in $tools; do
			printf "  • %s\n" "$tool"
		done
		printf "\n"
	done

	# Fix the printf format string - use escaped dashes in text
	os_caps=$(capitalize "$CURRENT_OS")
	# shellcheck disable=SC2183
	printf "%bTarget OS: %b%s%b\n" "$YELLOW" "$NC" "$os_caps" "$GREEN" "$NC"
	printf "\n"

	if prompt_yes_no "Proceed with installation?"; then
		return 0
	else
		return 1
	fi
}

# Main installation flow
main() {
	welcome

	# Select categories
	selected_categories=$(select_categories)

	if [ -z "$selected_categories" ]; then
		printf "%bNo categories selected. Exiting.%b\n" "$RED" "$NC"
		exit 1
	fi

	# Confirm installation
	# shellcheck disable=SC2086
	if confirm_install $selected_categories; then
		print_section "Installing Configurations"

		for category in $selected_categories; do
			printf "%bInstalling %s...%b\n" "$GREEN" "$category" "$NC"

			# Check if category installer exists
			if [ -f "$SCRIPT_DIR/install-${category}.sh" ]; then
				sh "$SCRIPT_DIR/install-${category}.sh" "$CURRENT_OS" "$REPO_ROOT"
			else
				printf "%b  No installer found for %s%b\n" "$YELLOW" "$category" "$NC"
				printf "  You'll need to configure manually or create installer\n"
			fi
		done

		print_section "Installation Complete"

		printf "%b✓ Installation completed!%b\n" "$GREEN" "$NC"
		printf "\n"
		printf "Next steps:\n"
		printf "  1. Restart your shell or run: source ~/.config/shell/rc\n"
		printf "  2. Check each tool's configuration\n"
		printf "  3. Customize as needed\n"
		printf "\n"
		printf "%bNote: Some tools may require manual installation%b\n" "$YELLOW" "$NC"
		printf "      See individual tool READMEs for details\n"
		printf "\n"
	else
		printf "%bInstallation cancelled.%b\n" "$RED" "$NC"
		exit 0
	fi
}

# Run main function
main "$@"
