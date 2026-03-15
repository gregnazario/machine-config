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
# - void: Void Linux
# - oracle: Oracle Linux
# - rocky: Rocky Linux
# - alpine: Alpine Linux
# - windows: Windows 11 (WSL or native via MSYS2/Git Bash)
# - freebsd: FreeBSD
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
        MSYS_NT-*|MINGW64_NT-*)
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
            alpine)
                echo "alpine"
                return 0
                ;;
            debian|raspbian)
                # Check if Raspberry Pi
                if grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null || \
                   grep -q "BCM" /proc/cpuinfo 2>/dev/null; then
                    echo "rpi"
                    return 0
                fi
                echo "ubuntu"  # Debian-based, use Ubuntu config
                return 0
                ;;
            rhel|centos)
                echo "rocky"  # RHEL-compatible, use Rocky config
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
    elif [ -f /etc/redhat-release ]; then
        echo "rocky"  # RHEL-based
        return 0
    elif [ -f /etc/debian_version ]; then
        # Check if Raspberry Pi
        if grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
            echo "rpi"
            return 0
        fi
        echo "ubuntu"  # Debian-based
        return 0
    fi

    # Check for FreeBSD
    if [ "$(uname)" = "FreeBSD" ]; then
        echo "freebsd"
        return 0
    fi

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
        fedora|ubuntu|arch|gentoo|void|oracle|rocky|alpine|windows|freebsd)
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
        x86_64|amd64)
            printf "x86_64"
            ;;
        i386|i686)
            printf "i386"
            ;;
        aarch64|arm64)
            printf "aarch64"
            ;;
        armv7l|armv6l)
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
        ubuntu|rpi)
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
        fedora|oracle|rocky)
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
    */detect-os.sh|*detect-os.sh)
        _main
        ;;
esac
