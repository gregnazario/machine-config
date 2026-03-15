#!/bin/sh
# Package mapping for different operating systems (21 systems!)
# Format: TOOL_NAME="OS1:package1,OS2:package2,OS3:package3"

# Navigation tools
FD="fedora:fd-find,ubuntu:fd-find,debian:fd-find,mint:fd-find,arch:fd,macos:fd,windows:fd,opensuse:fd-find,amazon:fd-find,almalinux:fd-find,solus:fd,freebsd:fd,openbsd:fd,netbsd:fd,nixos:fd"
RIPGREP="fedora:ripgrep,ubuntu:ripgrep,debian:ripgrep,mint:ripgrep,arch:ripgrep,macos:ripgrep,windows:ripgrep,opensuse:ripgrep,amazon:ripgrep,almalinux:ripgrep,solus:ripgrep,freebsd:ripgrep,openbsd:ripgrep,netbsd:ripgrep,nixos:ripgrep"
FZF="fedora:fzf,ubuntu:fzf,debian:fzf,mint:fzf,arch:fzf,macos:fzf,windows:fzf,opensuse:fzf,amazon:fzf,almalinux:fzf,solus:fzf,freebsd:fzf,openbsd:fzf,netbsd:fzf,nixos:fzf"
YAZI="fedora:yazi,ubuntu:yazi,debian:yazi,mint:yazi,arch:yazi,macos:yazi,opensuse:yazi,amazon:yazi,almalinux:yazi,solus:yazi,nixos:yazi"

# Text Editors
NEOVIM="fedora:neovim,ubuntu:neovim,debian:neovim,mint:neovim,arch:neovim,macos:neovim,windows:neovim,opensuse:neovim,amazon:neovim,almalinux:neovim,solus:neovim,freebsd:neovim,openbsd:neovim,netbsd:neovim,nixos:neovim"
HELiX="fedora:helix,ubuntu:helix,debian:helix,mint:helix,arch:helix,macos:helix,windows:helix,opensuse:helix,amazon:helix,almalinux:helix,solus:helix,freebsd:helix,openbsd:helix,netbsd:helix,nixos:helix"
EMACS="fedora:emacs,ubuntu:emacs,debian:emacs,mint:emacs,arch:emacs,macos:emacs,windows:emacs,opensuse:emacs,amazon:emacs,almalinux:emacs,solus:emacs,freebsd:emacs,openbsd:emacs,netbsd:emacs,nixos:emacs"

# Shells
ZSH="fedora:zsh,ubuntu:zsh,debian:zsh,mint:zsh,arch:zsh,macos:zsh,windows:zsh,opensuse:zsh,amazon:zsh,almalinux:zsh,solus:zsh,freebsd:zsh,openbsd:zsh,netbsd:zsh,nixos:zsh"
FISH="fedora:fish,ubuntu:fish,debian:fish,mint:fish,arch:fish,macos:fish,windows:fish,opensuse:fish,amazon:fish,almalinux:fish,solus:fish,freebsd:fish,openbsd:fish,netbsd:fish,nixos:fish"
NUSHELL="fedora:nu,ubuntu:nushell,debian:nushell,mint:nushell,arch:nushell,macos:nushell,windows:nushell,opensuse:nushell,amazon:nushell,almalinux:nushell,solus:nushell,nixos:nushell"

# Terminal Multiplexers
ZELLIJ="fedora:zellij,ubuntu:zellij,debian:zellij,mint:zellij,arch:zellij,macos:zellij,windows:zellij,opensuse:zellij,amazon:zellij,almalinux:zellij,solus:zellij,freebsd:zellij,openbsd:zellij,netbsd:zellij,nixos:zellij"
TMUX="fedora:tmux,ubuntu:tmux,debian:tmux,mint:tmux,arch:tmux,macos:tmux,windows:tmux,opensuse:tmux,amazon:tmux,almalinux:tmux,solus:tmux,freebsd:tmux,openbsd:tmux,netbsd:tmux,nixos:tmux"
SCREEN="fedora:screen,ubuntu:screen,debian:screen,mint:screen,arch:screen,macos:screen,opensuse:screen,amazon:screen,almalinux:screen,solus:screen,freebsd:screen,openbsd:screen,netbsd:screen,nixos:screen"

# Version Control
GIT="fedora:git,ubuntu:git,debian:git,mint:git,arch:git,macos:git,windows:git,opensuse:git,amazon:git,almalinux:git,solus:git,freebsd:git,openbsd:git,netbsd:git,nixos:git"
LAZYGIT="fedora:lazygit,ubuntu:lazygit,debian:lazygit,mint:lazygit,arch:lazygit,macos:lazygit,windows:lazygit,opensuse:lazygit,amazon:lazygit,almalinux:lazygit,solus:lazygit,freebsd:lazygit,openbsd:lazygit,netbsd:lazygit,nixos:lazygit"
GH="fedora:gh,ubuntu:gh,debian:gh,mint:gh,arch:gh,macos:gh,windows:gh,opensuse:gh,amazon:gh,almalinux:gh,solus:gh,freebsd:gh,openbsd:gh,netbsd:gh,nixos:gh"

# Monitoring
BTOP="fedora:btop,ubuntu:btop,debian:btop,mint:btop,arch:btop,macos:btop,windows:btop,opensuse:btop,amazon:btop,almalinux:btop,solus:btop,freebsd:btop,openbsd:btop,netbsd:btop,nixos:btop"
GLANCES="fedora:glances,ubuntu:glances,debian:glances,mint:glances,arch:glances,macos:glances,windows:glances,opensuse:glances,amazon:glances,almalinux:glances,solus:glances,freebsd:glances,openbsd:glances,netbsd:glances,nixos:glances"

# Network Tools
GPING="fedora:gping,ubuntu:gping,debian:gping,mint:gping,arch:gping,macos:gping,windows:gping,opensuse:gping,amazon:gping,almalinux:gping,solus:gping,freebsd:gping,openbsd:gping,netbsd:gping,nixos:gping"
HTTPie="fedora:httpie,ubuntu:httpie,debian:httpie,mint:httpie,arch:httpie,macos:httpie,windows:httpie,opensuse:httpie,amazon:httpie,almalinux:httpie,solus:httpie,freebsd:httpie,openbsd:httpie,netbsd:httpie,nixos:httpie"
SPEEDTEST="fedora:speedtest-cli,ubuntu:speedtest-cli,debian:speedtest-cli,mint:speedtest-cli,arch:speedtest-cli,macos:speedtest-cli,windows:speedtest-cli,opensuse:speedtest-cli,amazon:speedtest-cli,almalinux:speedtest-cli,solus:speedtest-cli,freebsd:speedtest-cli,openbsd:speedtest-cli,netbsd:speedtest-cli,nixos:speedtest-cli"

# Productivity
PRESENTERM="fedora:presenterm,ubuntu:presenterm,debian:presenterm,mint:presenterm,arch:presenterm,macos:presenterm,opensuse:presenterm,amazon:presenterm,almalinux:presenterm,solus:presenterm,nixos:presenterm"

# Transfer tools
ARIA2="fedora:aria2,ubuntu:aria2,debian:aria2,mint:aria2,arch:aria2,macos:aria2,windows:aria2,opensuse:aria2,amazon:aria2,almalinux:aria2,solus:aria2,freebsd:aria2,openbsd:aria2,netbsd:aria2,nixos:aria2"
WGET2="fedora:wget2,ubuntu:wget2,debian:wget2,mint:wget2,arch:wget2,windows:wget2,opensuse:wget2,amazon:wget2,almalinux:wget2,solus:wget2,freebsd:wget2,openbsd:wget2,netbsd:wget2,nixos:wget2"
CURLIE="fedora:curlie,ubuntu:curlie,debian:curlie,mint:curlie,arch:curlie,windows:curlie,opensuse:curlie,amazon:curlie,almalinux:curlie,solus:curlie,freebsd:curlie,openbsd:curlie,netbsd:curlie,nixos:curlie"

# Development
PYTHON="fedora:python3,ubuntu:python3,debian:python3,mint:python3,arch:python,macos:python@3,windows:python3,opensuse:python3,amazon:python3,almalinux:python3,solus:python3,freebsd:python3,openbsd:python3,netbsd:python3,nixos:python3"
RUST="fedora:rust,ubuntu:rustc,debian:rustc,mint:rustc,arch:rust,macos:rust,windows:rust,opensuse:rust,amazon:rust,almalinux:rust,solus:rust,freebsd:rust,openbsd:rust,netbsd:rust,nixos:rust"
NODEJS="fedora:nodejs,ubuntu:nodejs,debian:nodejs,mint:nodejs,arch:nodejs,macos:node,windows:nodejs,opensuse:nodejs,amazon:nodejs,almalinux:nodejs,solus:nodejs,freebsd:nodejs,openbsd:nodejs,netbsd:nodejs,nixos:nodejs"

# Documentation
TLDR="fedora:tldr,ubuntu:tldr,debian:tldr,mint:tldr,arch:tldr,macos:tldr,windows:tldr,opensuse:tldr,amazon:tldr,almalinux:tldr,solus:tldr,freebsd:tldr,openbsd:tldr,netbsd:tldr,nixos:tldr"
TEALDEER="fedora:tealdeer,ubuntu:tealdeer,debian:tealdeer,mint:tealdeer,arch:tealdeer,macos:tealdeer,windows:tealdeer,opensuse:tealdeer,amazon:tealdeer,almalinux:tealdeer,solus:tealdeer,freebsd:tealdeer,openbsd:tealdeer,netbsd:tealdeer,nixos:tealdeer"
CHEAT="fedora:cheat,ubuntu:cheat,debian:cheat,mint:cheat,arch:cheat,macos:cheat,windows:cheat,opensuse:cheat,amazon:cheat,almalinux:cheat,solus:cheat,freebsd:cheat,openbsd:cheat,netbsd:cheat,nixos:cheat"

# Security
AGE="fedora:age,ubuntu:age,debian:age,mint:age,arch:age,macos:age,windows:age,opensuse:age,amazon:age,almalinux:age,solus:age,freebsd:age,openbsd:age,netbsd:age,nixos:age"
1PASSWORD="fedora:1password-cli,ubuntu:1password-cli,debian:1password-cli,mint:1password-cli,arch:1password-cli,macos:1password-cli,windows:1password-cli,opensuse:1password-cli,amazon:1password-cli,almalinux:1password-cli,solus:1password-cli,freebsd:1password-cli,openbsd:1password-cli,netbsd:1password-cli,nixos:onepassword-cli"

# Archive tools
UNAR="fedora:unar,ubuntu:unar,debian:unar,mint:unar,arch:unar,macos:unar,windows:unar,opensuse:unar,amazon:unar,almalinux:unar,solus:unar,freebsd:unar,openbsd:unar,netbsd:unar,nixos:unar"
PIGZ="fedora:pigz,ubuntu:pigz,debian:pigz,mint:pigz,arch:pigz,macos:pigz,windows:pigz,opensuse:pigz,amazon:pigz,almalinux:pigz,solus:pigz,freebsd:pigz,openbsd:pigz,netbsd:pigz,nixos:pigz"
PXZ="fedora:pxz,ubuntu:pxz,debian:pxz,mint:pxz,arch:pxz,opensuse:pxz,amazon:pxz,almalinux:pxz,freebsd:pxz,netbsd:pxz,nixos:pxz"

# Fun
FASTFETCH="fedora:fastfetch,ubuntu:fastfetch,debian:fastfetch,mint:fastfetch,arch:fastfetch,macos:fastfetch,windows:fastfetch,opensuse:fastfetch,amazon:fastfetch,almalinux:fastfetch,solus:fastfetch,freebsd:fastfetch,openbsd:fastfetch,netbsd:fastfetch,nixos:fastfetch"
QALC="fedora:qalculate,ubuntu:qalculate-gtk,debian:qalculate-gtk,mint:qalculate-gtk,arch:qalculate-gtk,macos:qalculate,windows:qalculate,opensuse:qalculate,amazon:qalculate,almalinux:qalculate,solus:qalculate,freebsd:qalculate,openbsd:qalculate,netbsd:qalculate,nixos:qalculate"

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
