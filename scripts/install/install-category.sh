#!/bin/sh
# Generic category installer
# Usage: install-category.sh <category> <os_type> <repo_root>

set -e -u

CATEGORY="$1"
OS_TYPE="$2"
REPO_ROOT="$3"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Source package database
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "${SCRIPT_DIR}/packages.sh" ]; then
	. "${SCRIPT_DIR}/packages.sh"
fi

# Function to get package name for tool
get_package() {
	tool="$1"
	os="$2"

	# Convert tool to uppercase for variable lookup
	tool_upper=$(echo "$tool" | tr '[:lower:]' '[:upper:]' | tr '-' '_')

	# Try to get package from database
	if type get_package_name 2>/dev/null | grep -q 'function'; then
		pkg=$(get_package_name "$tool_upper" "$os")
		if [ -n "$pkg" ] && [ "$pkg" != "$tool" ]; then
			echo "$pkg"
			return 0
		fi
	fi

	# Fallback to tool name
	echo "$tool"
}

# Function to install packages
install_packages() {
	os="$1"
	shift
	packages="$*"

	if [ -z "$packages" ]; then
		return 0
	fi

	# Determine package manager and install
	case "$os" in
	macos)
		if command -v brew >/dev/null 2>&1; then
			brew install $packages 2>/dev/null || true
		else
			printf "${YELLOW}    ⚠ Homebrew not found, skipping packages${NC}\n"
		fi
		;;
	fedora|oracle|rocky)
		if command -v dnf >/dev/null 2>&1; then
			sudo dnf install -y $packages 2>/dev/null || true
		fi
		;;
	ubuntu|rpi)
		if command -v apt >/dev/null 2>&1; then
			sudo apt update -qq 2>/dev/null || true
			sudo apt install -y $packages 2>/dev/null || true
		fi
		;;
	arch)
		if command -v pacman >/dev/null 2>&1; then
			sudo pacman -S --noconfirm --needed $packages 2>/dev/null || true
		fi
		;;
	gentoo)
		if command -v emerge >/dev/null 2>&1; then
			sudo emerge --quiet app-portage/portage $packages 2>/dev/null || true
		fi
		;;
	void)
		if command -v xbps-install >/dev/null 2>&1; then
			sudo xbps-install -Sy $packages 2>/dev/null || true
		fi
		;;
	alpine)
		if command -v apk >/dev/null 2>&1; then
			sudo apk add --no-cache $packages 2>/dev/null || true
		fi
		;;
	freebsd)
		if command -v pkg >/dev/null 2>&1; then
			sudo pkg install -y $packages 2>/dev/null || true
		fi
		;;
	*)
		printf "${YELLOW}    ⚠ Unknown OS: ${os}, skipping packages${NC}\n"
		;;
	esac
}

printf "${BLUE}→ ${CATEGORY}${NC}\n"

# Create symlinks for all tools in this category
CATEGORY_DIR="${REPO_ROOT}/${CATEGORY}"

if [ ! -d "$CATEGORY_DIR" ]; then
	printf "${YELLOW}  ⚠ Category directory not found: ${CATEGORY_DIR}${NC}\n"
	printf "  Skipping...\n"
	exit 0
fi

# Collect all tools and their packages
tools_to_install=""
tools_list=""

# Find all tool directories in this category
for tool_dir in "${CATEGORY_DIR}"/*/; do
	# Check if directory exists
	[ -d "$tool_dir" ] || continue

	tool=$(basename "$tool_dir")

	# Get package name for this tool
	package=$(get_package "$tool" "$OS_TYPE")

	if [ -n "$tools_list" ]; then
		tools_list="${tools_list}, "
	fi
	tools_list="${tools_list}${tool}"

	if [ -n "$tools_to_install" ]; then
		tools_to_install="${tools_to_install} "
	fi
	tools_to_install="${tools_to_install}${package}"
done

# Install all packages at once
if [ -n "$tools_to_install" ]; then
	printf "  Installing packages: ${tools_list}...\n"
	install_packages "$OS_TYPE" $tools_to_install
fi

# Now symlink config files
for tool_dir in "${CATEGORY_DIR}"/*/; do
	[ -d "$tool_dir" ] || continue

	tool=$(basename "$tool_dir")

	# Check if base config exists
	if [ -d "${tool_dir}/base" ]; then
		success=0

		# Link all config files from base
		for config_file in "${tool_dir}/base"/.* "${tool_dir}/base"/*; do
			# Skip if no matches
			[ -e "$config_file" ] || continue

			# Get just the filename
			config_name=$(basename "$config_file")

			# Skip . and ..
			case "$config_name" in
				.|*) continue ;;
			esac

			# Determine target directory based on config file
			case "$config_name" in
				.zshrc)
					# Zsh config goes to home directory
					target_dir="${HOME}"
					;;
				config.fish)
					# Fish config goes to ~/.config/fish/
					target_dir="${HOME}/.config/fish"
					;;
				.*rc|.*_rc|.*profile)
					# Shell configs
					if [ "$tool" = "zsh" ]; then
						target_dir="${HOME}"
					elif [ "$tool" = "fish" ]; then
						target_dir="${HOME}/.config/fish"
					else
						target_dir="${HOME}/.config/${tool}"
					fi
					;;
				*)
					# Default to ~/.config/{tool}/
					target_dir="${HOME}/.config/${tool}"
					;;
			esac

			# Create target directory if it doesn't exist
			mkdir -p "$target_dir"

			# Create symlink
			target_file="${target_dir}/${config_name}"

			# Backup existing file
			if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
				mv "$target_file" "${target_file}.backup.$(date +%Y%m%d%H%M%S)"
			fi

			ln -sf "$config_file" "$target_file" 2>/dev/null && success=1
		done

		if [ $success -eq 1 ]; then
			printf "  ${GREEN}✓${NC} ${tool} configured\n"
		fi
	fi

	# Check for OS-specific overrides
	if [ -d "${tool_dir}/os/${OS_TYPE}" ]; then
		# Link OS-specific configs (will override base)
		for config_file in "${tool_dir}/os/${OS_TYPE}/"*; do
			[ -e "$config_file" ] || continue

			config_name=$(basename "$config_file")
			target_dir="${HOME}/.config/${tool}"
			target_file="${target_dir}/${config_name}"

			ln -sf "$config_file" "$target_file" 2>/dev/null
		done
	fi
done

printf "${GREEN}  ✓ ${CATEGORY} complete${NC}\n"
exit 0
