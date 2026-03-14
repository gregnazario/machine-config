#!/usr/bin/env bash
# OS Detection Utility
# Detects the current operating system and prints standardized OS name

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
    if [ -f /proc/version ] && grep -qi microsoft /proc/version; then
        echo "windows"
        return 0
    fi

    # Check for MSYS2/Git Bash on Windows
    if [ "$(uname -s)" = "MSYS_NT-" ] || [ "$(uname -s)" = "MINGW64_NT-" ]; then
        echo "windows"
        return 0
    fi

    # Linux distribution detection
    if [ -f /etc/os-release ]; then
        # Parse /etc/os-release for distribution info
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
    elif [ -f /etc/ubuntu-release ] || grep -q "Ubuntu" /etc/lsb-release 2>/dev/null; then
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
    local os=$(detect_os)

    case "$os" in
        macos)
            sw_vers -productVersion
            ;;
        fedora|ubuntu|arch|gentoo|void|oracle|rocky|alpine|windows|freebsd)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                echo "$VERSION_ID"
            fi
            ;;
        rpi)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                echo "$VERSION_ID"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Get architecture
detect_arch() {
    local arch=$(uname -m)

    case "$arch" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        i386|i686)
            echo "i386"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        armv7l|armv6l)
            echo "arm"
            ;;
        *)
            echo "$arch"
            ;;
    esac
}

# Check if running on specific OS family
is_debian_based() {
    local os=$(detect_os)
    [[ "$os" =~ ^(ubuntu|rpi)$ ]]
}

is_rpm_based() {
    local os=$(detect_os)
    [[ "$os" =~ ^(fedora|oracle|rocky)$ ]]
}

is_arch_based() {
    local os=$(detect_os)
    [ "$os" = "arch" ]
}

is_macos() {
    [ "$(detect_os)" = "macos" ]
}

is_windows() {
    [ "$(detect_os)" = "windows" ]
}

is_bsd() {
    local os=$(detect_os)
    [[ "$os" =~ ^(freebsd)$ ]]
}

# Export functions if sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    export -f detect_os
    export -f detect_os_version
    export -f detect_arch
    export -f is_debian_based
    export -f is_rpm_based
    export -f is_arch_based
    export -f is_macos
    export -f is_windows
    export -f is_bsd
fi

# Run detection if executed directly
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    OS=$(detect_os)
    VERSION=$(detect_os_version)
    ARCH=$(detect_arch)

    echo "OS:      $OS"
    echo "Version: $VERSION"
    echo "Arch:    $ARCH"
fi
