#!/bin/sh
# Package mapping for different operating systems
# Format: TOOL_NAME="OS1:package1,OS2:package2,OS3:package3"

# Navigation tools
FD="fedora:fd-find,ubuntu:fd-find,arch:fd,macos:fd,fedora:fd-find,ubuntu:fd-find,arch:fd"
RIPGREP="fedora:ripgrep,ubuntu:ripgrep,arch:ripgrep,macos:ripgrep"
FZF="fedora:fzf,ubuntu:fzf,arch:fzf,macos:fzf"
YAZI="fedora:yazi,ubuntu:yazi,arch:yazi,macos:yazi"

# Text Editors
NEOVIM="fedora:neovim,ubuntu:neovim,arch:neovim,macos:neovim"
HELiX="fedora:helix,ubuntu:helix,arch:helix,macos:helix"
EMACS="fedora:emacs,ubuntu:emacs,arch:emacs,macos:emacs"

# Shells
ZSH="fedora:zsh,ubuntu:zsh,arch:zsh,macos:zsh"
FISH="fedora:fish,ubuntu:fish,arch:fish,macos:fish"
NUSHELL="fedora:nu,ubuntu:nushell,arch:nushell,macos:nushell"

# Terminal Multiplexers
ZELLIJ="fedora:zellij,ubuntu:zellij,arch:zellij,macos:zellij"
TMUX="fedora:tmux,ubuntu:tmux,arch:tmux,macos:tmux"
SCREEN="fedora:screen,ubuntu:screen,arch:screen,macos:screen"

# Version Control
GIT="fedora:git,ubuntu:git,arch:git,macos:git"
LAZYGIT="fedora:lazygit,ubuntu:lazygit,arch:lazygit,macos:lazygit"
GH="fedora:gh,ubuntu:gh,arch:gh,macos:gh"

# Monitoring
BTOP="fedora:btop,ubuntu:btop,arch:btop,macos:btop"
GLANCES="fedora:glances,ubuntu:glances,arch:glances,macos:glances"

# Network Tools
GPING="fedora:gping,ubuntu:gping,arch:gping,macos:gping"
HTTPie="fedora:httpie,ubuntu:httpie,arch:httpie,macos:httpie"
SPEEDTEST="fedora:speedtest-cli,ubuntu:speedtest-cli,arch:speedtest-cli,macos:speedtest-cli"

# Productivity
PRESENTERM="fedora:presenterm,ubuntu:presenterm,arch:presenterm,macos:presenterm"

# Transfer tools
ARIA2="fedora:aria2,ubuntu:aria2,arch:aria2,macos:aria2"
WGET2="fedora:wget2,ubuntu:wget2,arch:wget2,macos:wget2"
CURLIE="fedora:curlie,ubuntu:curlie,arch:curlie,macos:curlie"

# Development
PYTHON="fedora:python3,ubuntu:python3,arch:python,macos:python@3"
RUST="fedora:rust,ubuntu:rustc,arch:rust,macos:rust"
NODEJS="fedora:nodejs,ubuntu:nodejs,arch:nodejs,macos:node"

# Documentation
TLDR="fedora:tldr,ubuntu:tldr,arch:tldr,macos:tldr"
TEALDEER="fedora:tealdeer,ubuntu:tealdeer,arch:tealdeer,macos:tealdeer"
CHEAT="fedora:cheat,ubuntu:cheat,arch:cheat,macos:cheat"

# Security
AGE="fedora:age,ubuntu:age,arch:age,macos:age"
1PASSWORD="fedora:1password-cli,ubuntu:1password-cli,arch:1password-cli,macos:1password-cli"

# Archive tools
UNAR="fedora:unar,ubuntu:unar,arch:unar,macos:unar"
PIGZ="fedora:pigz,ubuntu:pigz,arch:pigz,macos:pigz"
PXZ="fedora:pxz,ubuntu:pxz,arch:pxz,macos:pxz"

# Fun
FASTFETCH="fedora:fastfetch,ubuntu:fastfetch,arch:fastfetch,macos:fastfetch"
QALC="fedora:qalculate,ubuntu:qalculate-gtk,arch:qalculate-gtk,macos:qalculate"

# Helper function to get package name for a tool
get_package_name() {
    tool="$1"
    os="$2"

    # Get the variable value for this tool
    package_list=$(eval echo \$${tool})

    # Parse the package list
    IFS=','
    for entry in $package_list; do
        entry_os="${entry%%:*}"
        entry_pkg="${entry#*:}"

        if [ "$entry_os" = "$os" ]; then
            echo "$entry_pkg"
            return 0
        fi
    done

    # If not found, try tool name as package name
    echo "$tool"
    return 1
}

# Export function for use in other scripts
export -f get_package_name
