#!/bin/sh
# OS Detection Utility
# Detects the current operating system and prints standardized OS name
# POSIX-compliant shell script

# Supported OS names (lowercase):
# - macos: macOS (any version)
# - fedora: Fedora Linux
# - rpi: Raspberry Pi OS (Debian-based ARM)
# - arch: Arch Linux
# - gentoo: Gentoo Linux
# - ubuntu: Ubuntu Linux
# - debian: Debian Linux
# - mint: Linux Mint
# - void: Void Linux
# - oracle: Oracle Linux
# - rocky: Rocky Linux
# - almalinux: AlmaLinux
# - alpine: Alpine Linux
# - opensuse: openSUSE Leap/Tumbleweed
# - amazon: Amazon Linux 2023
# - solus: Solus Linux
# - freebsd: FreeBSD
# - openbsd: OpenBSD
# - netbsd: NetBSD
# - nixos: NixOS Linux
# - windows: Windows 11 (WSL or native via MSYS2/Git Bash)
# - unknown: Unable to detect

detect_os() {
	# Check for macOS first
	if [ "$(uname)" = "Darwin" ]; then
		echo "macos"
		return 0
	fi

	# Check for WSL (Windows Subsystem for Linux)
	if [ -f /proc/version ] && grep -qi microsoft /proc/version 2>/dev/null; then
		echo "windows"
		return 0
	fi

	# Check for MSYS2/Git Bash on Windows
	case "$(uname -s)" in
	MSYS_NT-* | MINGW64_NT-*)
		echo "windows"
		return 0
		;;
	esac

	# Linux distribution detection
	if [ -f /etc/os-release ]; then
		# Parse /etc/os-release for distribution info
		# Using shell source to read variables
		. /etc/os-release

		case "$ID" in
		fedora)
			echo "fedora"
			return 0
			;;
		ubuntu)
			echo "ubuntu"
			return 0
			;;
		debian)
			echo "debian"
			return 0
			;;
		linuxmint)
			echo "mint"
			return 0
			;;
		arch)
			echo "arch"
			return 0
			;;
		gentoo)
			echo "gentoo"
			return 0
			;;
		void)
			echo "void"
			return 0
			;;
		oracle)
			echo "oracle"
			return 0
			;;
		rocky)
			echo "rocky"
			return 0
			;;
		almalinux)
			echo "almalinux"
			return 0
			;;
		alpine)
			echo "alpine"
			return 0
			;;
		opensuse*)
			echo "opensuse"
			return 0
			;;
		amzn)
			echo "amazon"
			return 0
			;;
		solus)
			echo "solus"
			return 0
			;;
		nixos)
			echo "nixos"
			return 0
			;;
		raspbian)
			# Check if Raspberry Pi
			if grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null ||
				grep -q "BCM" /proc/cpuinfo 2>/dev/null; then
				echo "rpi"
				return 0
			fi
			echo "debian"  # Fallback to debian
			return 0
			;;
		rhel | centos)
			echo "rocky" # RHEL-compatible, use Rocky config
			return 0
			;;
		*)
			# Fallback: try to detect from release file
			;;
		esac
	fi

	# Fallback: Check specific release files
	if [ -f /etc/fedora-release ]; then
		echo "fedora"
		return 0
	elif [ -f /etc/arch-release ]; then
		echo "arch"
		return 0
	elif [ -f /etc/gentoo-release ]; then
		echo "gentoo"
		return 0
	elif [ -f /etc/ubuntu-release ] || grep -q Ubuntu /etc/lsb-release 2>/dev/null; then
		echo "ubuntu"
		return 0
	elif [ -f /etc/void-release ]; then
		echo "void"
		return 0
	elif [ -f /etc/oracle-release ]; then
		echo "oracle"
		return 0
	elif [ -f /etc/rocky-release ]; then
		echo "rocky"
		return 0
	elif [ -f /etc/alpine-release ]; then
		echo "alpine"
		return 0
	elif [ -f /etc/os-release ]; then
		# Check for openSUSE
		if grep -qi "opensuse" /etc/os-release 2>/dev/null; then
			echo "opensuse"
			return 0
		fi
		# Check for Amazon Linux
		if grep -qi "amazon" /etc/os-release 2>/dev/null; then
			echo "amazon"
			return 0
		fi
		# Check for Solus
		if grep -qi "solus" /etc/os-release 2>/dev/null; then
			echo "solus"
			return 0
		fi
		# Check for AlmaLinux
		if grep -qi "almalinux" /etc/os-release 2>/dev/null; then
			echo "almalinux"
			return 0
		fi
		# Check for NixOS
		if grep -qi "nixos" /etc/os-release 2>/dev/null; then
			echo "nixos"
			return 0
		fi
		# Check for Linux Mint
		if grep -qi "linuxmint" /etc/os-release 2>/dev/null; then
			echo "mint"
			return 0
		fi
	elif [ -f /etc/redhat-release ]; then
		# Check for AlmaLinux
		if grep -qi "almalinux" /etc/redhat-release 2>/dev/null; then
			echo "almalinux"
			return 0
		fi
		echo "rocky" # RHEL-based
		return 0
	elif [ -f /etc/debian_version ]; then
		# Not Raspberry Pi, so it's Debian
		echo "debian"
		return 0
	fi

	# Check for BSD systems
	case "$(uname)" in
	FreeBSD)
		echo "freebsd"
		return 0
		;;
	OpenBSD)
		echo "openbsd"
		return 0
		;;
	NetBSD)
		echo "netbsd"
		return 0
		;;
	esac

	# Unable to detect
	echo "unknown"
	return 1
}

# Get OS version (optional, more detailed)
detect_os_version() {
	os=$(detect_os)

	case "$os" in
	macos)
		sw_vers -productVersion
		;;
	fedora | ubuntu | debian | arch | gentoo | void | oracle | rocky | almalinux | alpine | opensuse | amazon | solus | mint | nixos | windows)
		if [ -f /etc/os-release ]; then
			. /etc/os-release
			printf "%s" "$VERSION_ID"
		fi
		;;
	rpi)
		if [ -f /etc/os-release ]; then
			. /etc/os-release
			printf "%s" "$VERSION_ID"
		fi
		;;
	*)
		printf "unknown"
		;;
	esac
}

# Get architecture
detect_arch() {
	arch=$(uname -m)

	case "$arch" in
	x86_64 | amd64)
		printf "x86_64"
		;;
	i386 | i686)
		printf "i386"
		;;
	aarch64 | arm64)
		printf "aarch64"
		;;
	armv7l | armv6l)
		printf "arm"
		;;
	*)
		printf "%s" "$arch"
		;;
	esac
}

# Check if running on specific OS family
is_debian_based() {
	os=$(detect_os)
	case "$os" in
	ubuntu | rpi)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

is_rpm_based() {
	os=$(detect_os)
	case "$os" in
	fedora | oracle | rocky | almalinux | opensuse | amazon)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

is_bsd() {
	os=$(detect_os)
	case "$os" in
	freebsd | openbsd | netbsd)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

is_arch_based() {
	os=$(detect_os)
	[ "$os" = "arch" ]
}

is_macos() {
	[ "$(detect_os)" = "macos" ]
}

is_windows() {
	[ "$(detect_os)" = "windows" ]
}

is_bsd() {
	os=$(detect_os)
	case "$os" in
	freebsd)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

# Run detection if executed directly
# Check if script is being sourced or run directly
# POSIX way to check if script is sourced:
# Attempt to get caller's shell - if $0 equals the current file, it's not sourced
_main() {
	OS=$(detect_os)
	VERSION=$(detect_os_version)
	ARCH=$(detect_arch)

	printf "OS:      %s\n" "$OS"
	printf "Version: %s\n" "$VERSION"
	printf "Arch:    %s\n" "$ARCH"
}

# Only run main if script is executed directly (not sourced)
# This is a heuristic that works in most cases
case "$0" in
*/detect-os.sh | *detect-os.sh)
	_main
	;;
esac
