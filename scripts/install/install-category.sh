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
NC='\033[0m'

printf "${YELLOW}Installing ${CATEGORY}...${NC}\n"

# Source common functions
if [ -f "${REPO_ROOT}/scripts/utils/common.sh" ]; then
	. "${REPO_ROOT}/scripts/utils/common.sh"
fi

# Create symlinks for all tools in this category
CATEGORY_DIR="${REPO_ROOT}/${CATEGORY}"

if [ ! -d "$CATEGORY_DIR" ]; then
	printf "${YELLOW}  ⚠ Category directory not found: ${CATEGORY_DIR}${NC}\n"
	printf "  Skipping...\n"
	exit 0
fi

# Find all tool directories in this category
for tool_dir in "${CATEGORY_DIR}"/*/; do
	# Check if directory exists
	[ -d "$tool_dir" ] || continue

	tool=$(basename "$tool_dir")

	# Check if base config exists
	if [ -d "${tool_dir}/base" ]; then
		printf "  → ${tool}: "
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
				.*rc|.*_rc|.*profile)
					# Shell configs go to ~/.config/{tool}/
					target_dir="${HOME}/.config/${tool}"
					;;
				.*)
					# Dotfiles go to home directory
					target_dir="${HOME}"
					;;
				*.toml|*.yaml|*.yml|*.json|*.kdl|*.lua)
					# Config files go to ~/.config/{tool}/
					target_dir="${HOME}/.config/${tool}"
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
			printf "${GREEN}✓${NC}\n"
		else
			printf "${YELLOW}○${NC} (no configs)\n"
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

printf "${GREEN}  ✓ ${CATEGORY} installed${NC}\n"
exit 0
