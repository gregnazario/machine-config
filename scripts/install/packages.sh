#!/bin/sh
# Package mapping for different operating systems (21 systems!)
# Lines broken up to avoid "Filename too long" errors

# Navigation tools
FD="fedora:fd-find,ubuntu:fd-find,debian:fd-find,mint:fd-find,arch:fd"
FD="${FD},macos:fd,windows:fd,opensuse:fd-find,amazon:fd-find"
FD="${FD},almalinux:fd-find,solus:fd,freebsd:fd,openbsd:fd"
FD="${FD},netbsd:fd,nixos:fd"

RIPGREP="fedora:ripgrep,ubuntu:ripgrep,debian:ripgrep,mint:ripgrep,arch:ripgrep"
RIPGREP="${RIPGREP},macos:ripgrep,windows:ripgrep,opensuse:ripgrep"
RIPGREP="${RIPGREP},amazon:ripgrep,almalinux:ripgrep,solus:ripgrep"
RIPGREP="${RIPGREP},freebsd:ripgrep,openbsd:ripgrep,netbsd:ripgrep,nixos:ripgrep"

FZF="fedora:fzf,ubuntu:fzf,debian:fzf,mint:fzf,arch:fzf,macos:fzf,windows:fzf"
FZF="${FZF},opensuse:fzf,amazon:fzf,almalinux:fzf,solus:fzf"
FZF="${FZF},freebsd:fzf,openbsd:fzf,netbsd:fzf,nixos:fzf"

YAZI="fedora:yazi,ubuntu:yazi,debian:yazi,mint:yazi,arch:yazi,macos:yazi"
YAZI="${YAZI},opensuse:yazi,amazon:yazi,almalinux:yazi,solus:yazi"
YAZI="${YAZI},nixos:yazi"

# Text Editors
NEOVIM="fedora:neovim,ubuntu:neovim,debian:neovim,mint:neovim,arch:neovim"
NEOVIM="${NEOVIM},macos:neovim,windows:neovim,opensuse:neovim"
NEOVIM="${NEOVIM},amazon:neovim,almalinux:neovim,solus:neovim"
NEOVIM="${NEOVIM},freebsd:neovim,openbsd:neovim,netbsd:neovim,nixos:neovim"

HELiX="fedora:helix,ubuntu:helix,debian:helix,mint:helix,arch:helix,macos:helix"
HELiX="${HELiX},windows:helix,opensuse:helix,amazon:helix,almalinux:helix"
HELiX="${HELiX},solus:helix,freebsd:helix,openbsd:helix,netbsd:helix,nixos:helix"

EMACS="fedora:emacs,ubuntu:emacs,debian:emacs,mint:emacs,arch:emacs,macos:emacs"
EMACS="${EMACS},windows:emacs,opensuse:emacs,amazon:emacs,almalinux:emacs"
EMACS="${EMACS},solus:emacs,freebsd:emacs,openbsd:emacs,netbsd:emacs,nixos:emacs"

# Shells
ZSH="fedora:zsh,ubuntu:zsh,debian:zsh,mint:zsh,arch:zsh,macos:zsh,windows:zsh"
ZSH="${ZSH},opensuse:zsh,amazon:zsh,almalinux:zsh,solus:zsh"
ZSH="${ZSH},freebsd:zsh,openbsd:zsh,netbsd:zsh,nixos:zsh"

FISH="fedora:fish,ubuntu:fish,debian:fish,mint:fish,arch:fish,macos:fish"
FISH="${FISH},windows:fish,opensuse:fish,amazon:fish,almalinux:fish"
FISH="${FISH},solus:fish,freebsd:fish,openbsd:fish,netbsd:fish,nixos:fish"

NUSHELL="fedora:nu,ubuntu:nushell,debian:nushell,mint:nushell,arch:nushell"
NUSHELL="${NUSHELL},macos:nushell,windows:nushell,opensuse:nushell"
NUSHELL="${NUSHELL},amazon:nushell,almalinux:nushell,solus:nushell"
NUSHELL="${NUSHELL},nixos:nushell"

# Terminal Multiplexers
ZELLIJ="fedora:zellij,ubuntu:zellij,debian:zellij,mint:zellij,arch:zellij"
ZELLIJ="${ZELLIJ},macos:zellij,windows:zellij,opensuse:zellij"
ZELLIJ="${ZELLIJ},amazon:zellij,almalinux:zellij,solus:zellij"
ZELLIJ="${ZELLIJ},freebsd:zellij,openbsd:zellij,netbsd:zellij,nixos:zellij"

TMUX="fedora:tmux,ubuntu:tmux,debian:tmux,mint:tmux,arch:tmux,macos:tmux"
TMUX="${TMUX},windows:tmux,opensuse:tmux,amazon:tmux,almalinux:tmux"
TMUX="${TMUX},solus:tmux,freebsd:tmux,openbsd:tmux,netbsd:tmux,nixos:tmux"

SCREEN="fedora:screen,ubuntu:screen,debian:screen,mint:screen,arch:screen,macos:screen"
SCREEN="${SCREEN},opensuse:screen,amazon:screen,almalinux:screen,solus:screen"
SCREEN="${SCREEN},freebsd:screen,openbsd:screen,netbsd:screen,nixos:screen"

# Version Control
GIT="fedora:git,ubuntu:git,debian:git,mint:git,arch:git,macos:git,windows:git"
GIT="${GIT},opensuse:git,amazon:git,almalinux:git,solus:git"
GIT="${GIT},freebsd:git,openbsd:git,netbsd:git,nixos:git"

LAZYGIT="fedora:lazygit,ubuntu:lazygit,debian:lazygit,mint:lazygit,arch:lazygit"
LAZYGIT="${LAZYGIT},macos:lazygit,windows:lazygit,opensuse:lazygit"
LAZYGIT="${LAZYGIT},amazon:lazygit,almalinux:lazygit,solus:lazygit"
LAZYGIT="${LAZYGIT},freebsd:lazygit,openbsd:lazygit,netbsd:lazygit"
LAZYGIT="${LAZYGIT},nixos:lazygit"

GH="fedora:gh,ubuntu:gh,debian:gh,mint:gh,arch:gh,macos:gh,windows:gh"
GH="${GH},opensuse:gh,amazon:gh,almalinux:gh,solus:gh"
GH="${GH},freebsd:gh,openbsd:gh,netbsd:gh,nixos:gh"

# Monitoring
BTOP="fedora:btop,ubuntu:btop,debian:btop,mint:btop,arch:btop,macos:btop,windows:btop"
BTOP="${BTOP},opensuse:btop,amazon:btop,almalinux:btop,solus:btop"
BTOP="${BTOP},freebsd:btop,openbsd:btop,netbsd:btop,nixos:btop"

GLANCES="fedora:glances,ubuntu:glances,debian:glances,mint:glances,arch:glances"
GLANCES="${GLANCES},macos:glances,windows:glances,opensuse:glances"
GLANCES="${GLANCES},amazon:glances,almalinux:glances,solus:glances"
GLANCES="${GLANCES},freebsd:glances,openbsd:glances,netbsd:glances,nixos:glances"

# Network Tools
GPING="fedora:gping,ubuntu:gping,debian:gping,mint:gping,arch:gping,macos:gping"
GPING="${GPING},windows:gping,opensuse:gping,amazon:gping,almalinux:gping"
GPING="${GPING},solus:gping,freebsd:gping,openbsd:gping,netbsd:gping,nixos:gping"

HTTPie="fedora:httpie,ubuntu:httpie,debian:httpie,mint:httpie,arch:httpie,macos:httpie"
HTTPie="${HTTPie},windows:httpie,opensuse:httpie,amazon:httpie,almalinux:httpie"
HTTPie="${HTTPie},solus:httpie,freebsd:httpie,openbsd:httpie,netbsd:httpie"
HTTPie="${HTTPie},nixos:httpie"

SPEEDTEST="fedora:speedtest-cli,ubuntu:speedtest-cli,debian:speedtest-cli"
SPEEDTEST="${SPEEDTEST},mint:speedtest-cli,arch:speedtest-cli,macos:speedtest-cli"
SPEEDTEST="${SPEEDTEST},windows:speedtest-cli,opensuse:speedtest-cli,amazon:speedtest-cli"
SPEEDTEST="${SPEEDTEST},almalinux:speedtest-cli,solus:speedtest-cli,freebsd:speedtest-cli"
SPEEDTEST="${SPEEDTEST},openbsd:speedtest-cli,netbsd:speedtest-cli,nixos:speedtest-cli"

# Productivity
PRESENTERM="fedora:presenterm,ubuntu:presenterm,debian:presenterm,mint:presenterm"
PRESENTERM="${PRESENTERM},arch:presenterm,macos:presenterm,opensuse:presenterm"
PRESENTERM="${PRESENTERM},amazon:presenterm,almalinux:presenterm,solus:presenterm"
PRESENTERM="${PRESENTERM},nixos:presenterm"

# Transfer tools
ARIA2="fedora:aria2,ubuntu:aria2,debian:aria2,mint:aria2,arch:aria2,macos:aria2"
ARIA2="${ARIA2},windows:aria2,opensuse:aria2,amazon:aria2,almalinux:aria2"
ARIA2="${ARIA2},solus:aria2,freebsd:aria2,openbsd:aria2,netbsd:aria2"
ARIA2="${ARIA2},nixos:aria2"

WGET2="fedora:wget2,ubuntu:wget2,debian:wget2,mint:wget2,arch:wget2,windows:wget2"
WGET2="${WGET2},opensuse:wget2,amazon:wget2,almalinux:wget2,solus:wget2"
WGET2="${WGET2},freebsd:wget2,openbsd:wget2,netbsd:wget2,nixos:wget2"

CURLIE="fedora:curlie,ubuntu:curlie,debian:curlie,mint:curlie,arch:curlie"
CURLIE="${CURLIE},windows:curlie,opensuse:curlie,amazon:curlie,almalinux:curlie"
CURLIE="${CURLIE},solus:curlie,freebsd:curlie,openbsd:curlie,netbsd:curlie"
CURLIE="${CURLIE},nixos:curlie"

# Development
PYTHON="fedora:python3,ubuntu:python3,debian:python3,mint:python3,arch:python"
PYTHON="${PYTHON},macos:python@3,windows:python3,opensuse:python3"
PYTHON="${PYTHON},amazon:python3,almalinux:python3,solus:python3"
PYTHON="${PYTHON},freebsd:python3,openbsd:python3,netbsd:python3"
PYTHON="${PYTHON},nixos:python3"

RUST="fedora:rust,ubuntu:rustc,debian:rustc,mint:rustc,arch:rust,macos:rust"
RUST="${RUST},windows:rust,opensuse:rust,amazon:rust,almalinux:rust"
RUST="${RUST},solus:rust,freebsd:rust,openbsd:rust,netbsd:rust,nixos:rust"

NODEJS="fedora:nodejs,ubuntu:nodejs,debian:nodejs,mint:nodejs,arch:nodejs,macos:node"
NODEJS="${NODEJS},windows:nodejs,opensuse:nodejs,amazon:nodejs,almalinux:nodejs"
NODEJS="${NODEJS},solus:nodejs,freebsd:nodejs,openbsd:nodejs,netbsd:nodejs"
NODEJS="${NODEJS},nixos:nodejs"

# Documentation
TLDR="fedora:tldr,ubuntu:tldr,debian:tldr,mint:tldr,arch:tldr,macos:tldr"
TLDR="${TLDR},windows:tldr,opensuse:tldr,amazon:tldr,almalinux:tldr,solus:tldr"
TLDR="${TLDR},freebsd:tldr,openbsd:tldr,netbsd:tldr,nixos:tldr"

TEALDEER="fedora:tealdeer,ubuntu:tealdeer,debian:tealdeer,mint:tealdeer"
TEALDEER="${TEALDEER},arch:tealdeer,macos:tealdeer,windows:tealdeer"
TEALDEER="${TEALDEER},opensuse:tealdeer,amazon:tealdeer,almalinux:tealdeer"
TEALDEER="${TEALDEER},solus:tealdeer,freebsd:tealdeer,openbsd:tealdeer"
TEALDEER="${TEALDEER},netbsd:tealdeer,nixos:tealdeer"

CHEAT="fedora:cheat,ubuntu:cheat,debian:cheat,mint:cheat,arch:cheat,macos:cheat"
CHEAT="${CHEAT},windows:cheat,opensuse:cheat,amazon:cheat,almalinux:cheat"
CHEAT="${CHEAT},solus:cheat,freebsd:cheat,openbsd:cheat,netbsd:cheat"
CHEAT="${CHEAT},nixos:cheat"

# Security
AGE="fedora:age,ubuntu:age,debian:age,mint:age,arch:age,macos:age,windows:age"
AGE="${AGE},opensuse:age,amazon:age,almalinux:age,solus:age"
AGE="${AGE},freebsd:age,openbsd:age,netbsd:age,nixos:age"

1PASSWORD="fedora:1password-cli,ubuntu:1password-cli,debian:1password-cli"
1PASSWORD="${1PASSWORD},mint:1password-cli,arch:1password-cli,macos:1password-cli"
1PASSWORD="${1PASSWORD},windows:1password-cli,opensuse:1password-cli,amazon:1password-cli"
1PASSWORD="${1PASSWORD},almalinux:1password-cli,solus:1password-cli,freebsd:1password-cli"
1PASSWORD="${1PASSWORD},openbsd:1password-cli,netbsd:1password-cli"
1PASSWORD="${1PASSWORD},nixos:onepassword-cli"

# Archive tools
UNAR="fedora:unar,ubuntu:unar,debian:unar,mint:unar,arch:unar,macos:unar,windows:unar"
UNAR="${UNAR},opensuse:unar,amazon:unar,almalinux:unar,solus:unar"
UNAR="${UNAR},freebsd:unar,openbsd:unar,netbsd:unar,nixos:unar"

PIGZ="fedora:pigz,ubuntu:pigz,debian:pigz,mint:pigz,arch:pigz,macos:pigz,windows:pigz"
PIGZ="${PIGZ},opensuse:pigz,amazon:pigz,almalinux:pigz,solus:pigz"
PIGZ="${PIGZ},freebsd:pigz,openbsd:pigz,netbsd:pigz,nixos:pigz"

PXZ="fedora:pxz,ubuntu:pxz,debian:pxz,mint:pxz,arch:pxz,opensuse:pxz"
PXZ="${PXZ},amazon:pxz,almalinux:pxz,freebsd:pxz,netbsd:pxz,nixos:pxz"

# Fun
FASTFETCH="fedora:fastfetch,ubuntu:fastfetch,debian:fastfetch,mint:fastfetch"
FASTFETCH="${FASTFETCH},arch:fastfetch,macos:fastfetch,windows:fastfetch"
FASTFETCH="${FASTFETCH},opensuse:fastfetch,amazon:fastfetch,almalinux:fastfetch"
FASTFETCH="${FASTFETCH},solus:fastfetch,freebsd:fastfetch,openbsd:fastfetch"
FASTFETCH="${FASTFETCH},netbsd:fastfetch,nixos:fastfetch"

QALC="fedora:qalculate,ubuntu:qalculate-gtk,debian:qalculate-gtk,mint:qalculate-gtk"
QALC="${QALC},arch:qalculate-gtk,macos:qalculate,windows:qalculate"
QALC="${QALC},opensuse:qalculate,amazon:qalculate,almalinux:qalculate"
QALC="${QALC},solus:qalculate,freebsd:qalculate,openbsd:qalculate"
QALC="${QALC},netbsd:qalculate,nixos:qalculate"

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
