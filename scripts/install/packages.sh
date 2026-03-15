#!/bin/sh
# Package mapping for different operating systems
# Format: TOOL_NAME="OS1:package1,OS2:package2,OS3:package3,windows:choco_package"

# Navigation tools
FD="fedora:fd-find,ubuntu:fd-find,arch:fd,macos:fd,windows:fd,opensuse:fd-find,amazon:fd-find"
RIPGREP="fedora:ripgrep,ubuntu:ripgrep,arch:ripgrep,macos:ripgrep,windows:ripgrep,opensuse:ripgrep,amazon:ripgrep"
FZF="fedora:fzf,ubuntu:fzf,arch:fzf,macos:fzf,windows:fzf,opensuse:fzf,amazon:fzf"
YAZI="fedora:yazi,ubuntu:yazi,arch:yazi,macos:yazi,opensuse:yazi"

# Text Editors
NEOVIM="fedora:neovim,ubuntu:neovim,arch:neovim,macos:neovim,windows:neovim,opensuse:neovim,amazon:neovim"
HELiX="fedora:helix,ubuntu:helix,arch:helix,macos:helix,windows:helix,opensuse:helix,amazon:helix"
EMACS="fedora:emacs,ubuntu:emacs,arch:emacs,macos:emacs,windows:emacs,opensuse:emacs,amazon:emacs"

# Shells
ZSH="fedora:zsh,ubuntu:zsh,arch:zsh,macos:zsh,windows:zsh,opensuse:zsh,amazon:zsh"
FISH="fedora:fish,ubuntu:fish,arch:fish,macos:fish,windows:fish,opensuse:fish,amazon:fish"
NUSHELL="fedora:nu,ubuntu:nushell,arch:nushell,macos:nushell,windows:nushell,opensuse:nushell,amazon:nushell"

# Terminal Multiplexers
ZELLIJ="fedora:zellij,ubuntu:zellij,arch:zellij,macos:zellij,windows:zellij,opensuse:zellij,amazon:zellij"
TMUX="fedora:tmux,ubuntu:tmux,arch:tmux,macos:tmux,windows:tmux,opensuse:tmux,amazon:tmux"
SCREEN="fedora:screen,ubuntu:screen,arch:screen,macos:screen,opensuse:screen,amazon:screen"

# Version Control
GIT="fedora:git,ubuntu:git,arch:git,macos:git,windows:git,opensuse:git,amazon:git"
LAZYGIT="fedora:lazygit,ubuntu:lazygit,arch:lazygit,macos:lazygit,windows:lazygit,opensuse:lazygit"
GH="fedora:gh,ubuntu:gh,arch:gh,macos:gh,windows:gh,opensuse:gh,amazon:gh"

# Monitoring
BTOP="fedora:btop,ubuntu:btop,arch:btop,macos:btop,windows:btop,opensuse:btop,amazon:btop"
GLANCES="fedora:glances,ubuntu:glances,arch:glances,macos:glances,windows:glances,opensuse:glances,amazon:glances"

# Network Tools
GPING="fedora:gping,ubuntu:gping,arch:gping,macos:gping,windows:gping,opensuse:gping,amazon:gping"
HTTPie="fedora:httpie,ubuntu:httpie,arch:httpie,macos:httpie,windows:httpie,opensuse:httpie,amazon:httpie"
SPEEDTEST="fedora:speedtest-cli,ubuntu:speedtest-cli,arch:speedtest-cli,macos:speedtest-cli,windows:speedtest-cli,opensuse:speedtest-cli,amazon:speedtest-cli"

# Productivity
PRESENTERM="fedora:presenterm,ubuntu:presenterm,arch:presenterm,macos:presenterm,opensuse:presenterm"

# Transfer tools
ARIA2="fedora:aria2,ubuntu:aria2,arch:aria2,macos:aria2,windows:aria2,opensuse:aria2,amazon:aria2"
WGET2="fedora:wget2,ubuntu:wget2,arch:wget2,windows:wget2,opensuse:wget2,amazon:wget2"
CURLIE="fedora:curlie,ubuntu:curlie,arch:curlie,windows:curlie,opensuse:curlie,amazon:curlie"

# Development
PYTHON="fedora:python3,ubuntu:python3,arch:python,macos:python@3,windows:python3,opensuse:python3,amazon:python3"
RUST="fedora:rust,ubuntu:rustc,arch:rust,macos:rust,windows:rust,opensuse:rust,amazon:rust"
NODEJS="fedora:nodejs,ubuntu:nodejs,arch:nodejs,macos:node,windows:nodejs,opensuse:nodejs,amazon:nodejs"

# Documentation
TLDR="fedora:tldr,ubuntu:tldr,arch:tldr,macos:tldr,windows:tldr,opensuse:tldr,amazon:tldr"
TEALDEER="fedora:tealdeer,ubuntu:tealdeer,arch:tealdeer,macos:tealdeer,windows:tealdeer,opensuse:tealdeer,amazon:tealdeer"
CHEAT="fedora:cheat,ubuntu:cheat,arch:cheat,macos:cheat,windows:cheat,opensuse:cheat,amazon:cheat"

# Security
AGE="fedora:age,ubuntu:age,arch:age,macos:age,windows:age,opensuse:age,amazon:age"
1PASSWORD="fedora:1password-cli,ubuntu:1password-cli,arch:1password-cli,macos:1password-cli,windows:1password-cli,opensuse:1password-cli,amazon:1password-cli"

# Archive tools
UNAR="fedora:unar,ubuntu:unar,arch:unar,macos:unar,windows:unar,opensuse:unar,amazon:unar"
PIGZ="fedora:pigz,ubuntu:pigz,arch:pigz,macos:pigz,windows:pigz,opensuse:pigz,amazon:pigz"
PXZ="fedora:pxz,ubuntu:pxz,arch:pxz,opensuse:pxz,amazon:pxz"

# Fun
FASTFETCH="fedora:fastfetch,ubuntu:fastfetch,arch:fastfetch,macos:fastfetch,windows:fastfetch,opensuse:fastfetch,amazon:fastfetch"
QALC="fedora:qalculate,ubuntu:qalculate-gtk,arch:qalculate-gtk,macos:qalculate,windows:qalculate,opensuse:qalculate,amazon:qalculate"

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
