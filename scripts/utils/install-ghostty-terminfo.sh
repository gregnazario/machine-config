#!/bin/sh
# Install Ghostty terminfo on remote systems
# Run this on the remote machine where you'll use Ghostty

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

printf "${GREEN}Installing Ghostty terminfo...${NC}\n\n"

# Check if we have ncurses sources
if command -v tic >/dev/null 2>&1; then
    # Method 1: Install from Ghostty repository
    printf "${YELLOW}Downloading terminfo from Ghostty...${NC}\n"

    # Create temp directory
    tmpdir=$(mktemp -d)
    cd "$tmpdir"

    # Download the terminfo file
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/mitchellh/ghostty/master/src/ghostty.terminfo -o ghostty.terminfo
    elif command -v wget >/dev/null 2>&1; then
        wget -q https://raw.githubusercontent.com/mitchellh/ghostty/master/src/ghostty.terminfo -O ghostty.terminfo
    else
        printf "${RED}Error: Neither curl nor wget available${NC}\n"
        exit 1
    fi

    # Compile and install
    printf "${YELLOW}Compiling terminfo...${NC}\n"
    tic -x ghostty.terminfo

    # Cleanup
    cd /
    rm -rf "$tmpdir"

    printf "${GREEN}✓ Ghostty terminfo installed successfully!${NC}\n"
    printf "\nYou can now set TERM=xterm-ghostty in your Ghostty settings.\n"

else
    printf "${RED}Error: tic (terminfo compiler) not found${NC}\n"
    printf "\nInstall ncurses:\n"
    printf "  Alpine: apk add ncurses-terminfo\n"
    printf "  Debian/Ubuntu: apt install ncurses-term\n"
    printf "  Fedora: dnf install ncurses-devel\n"
    printf "  Arch: pacman -S ncurses\n"
    exit 1
fi
