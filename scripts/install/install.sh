#!/usr/bin/env bash
# Interactive installer for Greg's Dotfiles
# Detects OS and lets user choose which tools to configure

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
# shellcheck source=../utils/detect-os.sh
if [ -f "$SCRIPT_DIR/../utils/detect-os.sh" ]; then
    source "$SCRIPT_DIR/../utils/detect-os.sh"
fi

# shellcheck source=../utils/common.sh
if [ -f "$SCRIPT_DIR/../utils/common.sh" ]; then
    source "$SCRIPT_DIR/../utils/common.sh"
fi

# Tool categories with descriptions
declare -A TOOL_CATEGORIES=(
    ["terminals"]="Terminal Multiplexers (zellij, tmux, screen)"
    ["editors"]="Text Editors (neovim, helix, emacs)"
    ["shells"]="Shell Configurations (zsh, fish, nushell)"
    ["navigation"]="File Navigation (yazi, fd, ripgrep, fzf)"
    ["monitoring"]="System Monitoring (btop, glances, modern-utils)"
    ["version-control"]="Version Control (git, gh, lazygit, git-fuzzy)"
    ["network"]="Network Tools (gping, httpie, speedtest, bandwhich)"
    ["productivity"]="Productivity Tools (presenterm, todotxt, jira-cli)"
    ["transfer"]="Download/Transfer (aria2, curlie, wget2)"
    ["development"]="Dev Tools (python, rust, nodejs, project-templates)"
    ["containers"]="Container Tools (nix, docker, kubernetes)"
    ["security"]="Security Tools (age, ssh, vault, totp)"
    ["archive"]="Archive Tools (compressors, parallel, unar, image-tools)"
    ["documentation"]="Documentation (tldr, man, cheat, docuum)"
    ["fun"]="Fun Utilities (fetch tools, qalc, etc)"
)

# Available tools in each category
declare -A CATEGORY_TOOLS=(
    ["terminals"]="zellij tmux screen"
    ["editors"]="neovim helix emacs"
    ["shells"]="zsh fish nushell"
    ["navigation"]="yazi fd ripgrep fzf"
    ["monitoring"]="btop glances modern-utils"
    ["version-control"]="git gh lazygit git-fuzzy"
    ["network"]="gping httpie speedtest bandwhich"
    ["productivity"]="presenterm todotxt jira-cli terminal-notes"
    ["transfer"]="aria2 curlie wget2"
    ["development"]="python rust nodejs project-templates"
    ["containers"]="nix docker kubernetes version-managers"
    ["security"]="age ssh vault totp"
    ["archive"]="compressors parallel unar image-tools"
    ["documentation"]="tldr man cheat docuum"
    ["fun"]="fetch utilities"
)

# Header
print_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}        ${GREEN}Greg's Dotfiles - Interactive Installer${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect OS (fallback if detect-os.sh not available)
detect_os_fallback() {
    if [ "$(uname)" = "Darwin" ]; then
        echo "macos"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/gentoo-release ]; then
        echo "gentoo"
    elif [ -f /etc/ubuntu-release ] || grep -q Ubuntu /etc/os-release 2>/dev/null; then
        echo "ubuntu"
    elif [ -f /etc/void-release ]; then
        echo "void"
    elif [ -f /etc/oracle-release ]; then
        echo "oracle"
    elif [ -f /etc/rocky-release ]; then
        echo "rocky"
    elif [ -f /etc/alpine-release ]; then
        echo "alpine"
    elif grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
        echo "rpi"
    elif [ "$(uname)" = "Linux" ] && grep -q microsoft /proc/version 2>/dev/null; then
        echo "windows"
    elif [ "$(uname)" = "FreeBSD" ]; then
        echo "freebsd"
    else
        echo "unknown"
    fi
}

# Get current OS
CURRENT_OS=$(detect_os_fallback)

# Print system info
print_system_info() {
    echo -e "${BLUE}System Information:${NC}"
    echo -e "  OS:        ${GREEN}$(capitalize "$CURRENT_OS")${NC}"
    echo -e "  Hostname:  ${GREEN}$(hostname)${NC}"
    echo -e "  User:      ${GREEN}$(whoami)${NC}"
    echo ""
}

# Capitalize first letter
capitalize() {
    echo "$1" | sed 's/./\U&/'
}

# Print section header
print_section() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Prompt yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi

    while true; do
        read -rp "$(echo -e ${YELLOW}→${NC} $prompt)" response
        response=${response:-$default}

        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo -e "${RED}Please answer yes or no.${NC}"
                ;;
        esac
    done
}

# Select from options
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local default="${options[0]}"

    echo -e "${YELLOW}→${NC} $prompt"
    echo ""

    local i=1
    for opt in "${options[@]}"; do
        echo -e "  ${CYAN}$i)${NC} $opt"
        ((i++))
    done
    echo ""

    while true; do
        read -rp "$(echo -e ${YELLOW}Choice [1-${#options[@]}] [${default}]:${NC} )" choice
        choice=${choice:-1}

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        else
            echo -e "${RED}Invalid choice. Please enter a number between 1 and ${#options[@]}.${NC}"
        fi
    done
}

# Multi-select from options
prompt_multi_select() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "${YELLOW}→${NC} $prompt"
    echo -e "  ${CYAN}Enter numbers separated by spaces (e.g., '1 3 5')${NC}"
    echo ""

    local i=1
    for opt in "${options[@]}"; do
        echo -e "  ${CYAN}$i)${NC} $opt"
        ((i++))
    done
    echo ""

    read -rp "$(echo -e ${YELLOW}Selection [1-${#options[@]}] (all):${NC} )" selection
    selection=${selection:-$(seq -s " " 1 "${#options[@]}")}

    local selected=()
    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#options[@]}" ]; then
            selected+=("${options[$((num-1))]}")
        fi
    done

    echo "${selected[@]}"
}

# Display welcome message
welcome() {
    print_header
    print_system_info

    echo -e "${GREEN}Welcome to the interactive dotfiles installer!${NC}"
    echo ""
    echo "This installer will help you:"
    echo "  • Select which tools to configure"
    echo "  • Install tools (optional)"
    echo "  • Apply OS-specific configuration layers"
    echo "  • Create symlinks to your home directory"
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Select categories
select_categories() {
    print_section "Step 1: Select Categories"

    echo "Select which categories of tools you want to configure:"
    echo ""

    local categories=("${!TOOL_CATEGORIES[@]}")

    local i=1
    for cat in "${categories[@]}"; do
        echo -e "  ${CYAN}$i)${NC} ${TOOL_CATEGORIES[$cat]}"
        ((i++))
    done
    echo -e "  ${CYAN}a)${NC} All categories"
    echo ""

    read -rp "$(echo -e ${YELLOW}Selection [1-${#categories[@]} or 'a' for all]:${NC} )" selection

    if [[ "$selection" =~ ^[Aa]$ ]]; then
        echo "${categories[@]}"
    else
        local selected=()
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#categories[@]}" ]; then
                selected+=("${categories[$((num-1))]}")
            fi
        done
        echo "${selected[@]}"
    fi
}

# Select tools in a category
select_tools_in_category() {
    local category="$1"
    local tools=($CATEGORY_TOOLS[$category])

    print_section "Step 2: Select $category Tools"

    echo "Select which ${category} tools to configure:"
    echo ""

    local i=1
    for tool in "${tools[@]}"; do
        echo -e "  ${CYAN}$i)${NC} $tool"
        ((i++))
    done
    echo -e "  ${CYAN}a)${NC} All tools"
    echo ""

    read -rp "$(echo -e ${YELLOW}Selection [1-${#tools[@]} or 'a' for all]:${NC} )" selection

    if [[ "$selection" =~ ^[Aa]$ ]]; then
        echo "${tools[@]}"
    else
        local selected=()
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#tools[@]}" ]; then
                selected+=("${tools[$((num-1))]}")
            fi
        done
        echo "${selected[@]}"
    fi
}

# Confirm installation
confirm_install() {
    print_section "Step 3: Confirm Installation"

    echo "Summary of selections:"
    echo ""

    # Display summary
    for category in "$@"; do
        echo -e "${CYAN}$category:${NC}"
        for tool in $(echo $CATEGORY_TOOLS[$category]); do
            echo "  • $tool"
        done
        echo ""
    done

    echo -e "${YELLOW}Target OS: ${GREEN}$(capitalize "$CURRENT_OS")${NC}"
    echo ""

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
    local selected_categories
    selected_categories=$(select_categories)
    selected_categories=($selected_categories)

    if [ ${#selected_categories[@]} -eq 0 ]; then
        echo -e "${RED}No categories selected. Exiting.${NC}"
        exit 1
    fi

    # For now, install all selected categories
    # In future, can add per-tool selection

    if confirm_install "${selected_categories[@]}"; then
        print_section "Installing Configurations"

        for category in "${selected_categories[@]}"; do
            echo -e "${GREEN}Installing $category...${NC}"

            # Check if category installer exists
            if [ -f "$SCRIPT_DIR/install-${category}.sh" ]; then
                bash "$SCRIPT_DIR/install-${category}.sh" "$CURRENT_OS" "$REPO_ROOT"
            else
                echo -e "${YELLOW}  No installer found for $category${NC}"
                echo -e "  You'll need to configure manually or create installer"
            fi
        done

        print_section "Installation Complete"

        echo -e "${GREEN}✓ Installation completed!${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Restart your shell or run: source ~/.config/shell/rc"
        echo "  2. Check each tool's configuration"
        echo "  3. Customize as needed"
        echo ""
        echo -e "${YELLOW}Note: Some tools may require manual installation${NC}"
        echo "      See individual tool READMEs for details"
        echo ""
    else
        echo -e "${RED}Installation cancelled.${NC}"
        exit 0
    fi
}

# Run main function
main "$@"
