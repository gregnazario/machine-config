#!/bin/sh
# Bootstrap installer - Checks for Python 3 and runs the main installer
# POSIX-compliant

set -e -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source OS detection
# shellcheck source=scripts/utils/detect-os.sh
# shellcheck disable=SC1091
if [ -f "$SCRIPT_DIR/utils/detect-os.sh" ]; then
	. "$SCRIPT_DIR/utils/detect-os.sh"
else
	# Simple fallback detection
	if [ "$(uname)" = "Darwin" ]; then
		CURRENT_OS="macos"
	elif [ -f /etc/fedora-release ]; then
		CURRENT_OS="fedora"
	elif [ -f /etc/arch-release ]; then
		CURRENT_OS="arch"
	elif grep -q Ubuntu /etc/os-release 2>/dev/null; then
		CURRENT_OS="ubuntu"
	else
		CURRENT_OS="unknown"
	fi
fi

# Detect OS
if [ -z "${CURRENT_OS:-}" ]; then
	CURRENT_OS=$(detect_os)
fi

# Check if Python 3 is available
if command -v python3 >/dev/null 2>&1; then
	PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
	# Check if it's Python 3
	if python --version 2>&1 | grep -q "Python 3"; then
		PYTHON_CMD="python"
	else
		PYTHON_CMD=""
	fi
else
	PYTHON_CMD=""
fi

# Function to install Python 3
install_python() {
	os="$1"

	printf "%bPython 3 not found. Attempting to install...%b\n" "$YELLOW" "$NC"
	printf "%b→ Installing Python 3 for %s%b\n\n" "$BLUE" "$os" "$NC"

	case "$os" in
	macos)
		if command -v brew >/dev/null 2>&1; then
			brew install python@3
		else
			printf "%bERROR: Homebrew not found. Please install Homebrew first:%b\n" "$RED" "$NC"
			printf "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"\n"
			return 1
		fi
		;;
	fedora | oracle | rocky)
		sudo dnf install -y python3 python3-pip
		;;
	ubuntu | rpi)
		sudo apt update
		sudo apt install -y python3 python3-pip
		;;
	arch)
		sudo pacman -S --noconfirm python python-pip
		;;
	void)
		sudo xbps-install -Sy python3 python3-pip
		;;
	gentoo)
		sudo emerge --quiet dev-lang/python
		;;
	alpine)
		sudo apk add python3 py3-pip
		;;
	freebsd)
		sudo pkg install -y python3
		;;
	windows)
		printf "%bERROR: Please install Python 3 manually on Windows%b\n" "$RED" "$NC"
		printf "  Download from: https://www.python.org/downloads/\n"
		return 1
		;;
	*)
		printf "%bERROR: Don't know how to install Python 3 on: %s%b\n" "$RED" "$os" "$NC"
		printf "  Please install Python 3 manually\n"
		return 1
		;;
	esac

	# Verify installation
	if command -v python3 >/dev/null 2>&1; then
		printf "%b✓ Python 3 installed successfully%b\n\n" "$GREEN" "$NC"
		return 0
	else
		printf "%b✗ Python 3 installation failed%b\n" "$RED" "$NC"
		return 1
	fi
}

# If Python not found, try to install it
if [ -z "$PYTHON_CMD" ]; then
	printf "%b═══════════════════════════════════════════════════════════%b\n" "$YELLOW" "$NC"
	printf "%b  Python 3 Required%b\n" "$YELLOW" "$NC"
	printf "%b═══════════════════════════════════════════════════════════%b\n\n" "$YELLOW" "$NC"

	printf "The interactive installer requires Python 3.6 or higher.\n"
	printf "Detected OS: %b%s%b\n\n" "$GREEN" "$CURRENT_OS" "$NC"

	# Try to install automatically
	if install_python "$CURRENT_OS"; then
		PYTHON_CMD="python3"
	else
		printf "\n%bERROR: Python 3 installation failed%b\n" "$RED" "$NC"
		printf "\nPlease install Python 3 manually and run this script again.\n"
		exit 1
	fi
fi

# Check Python version (need 3.6+)
PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 6 ]; }; then
	printf "%bERROR: Python 3.6 or higher is required%b\n" "$RED" "$NC"
	printf "You have Python %s\n" "$PYTHON_VERSION"
	printf "\nAttempting to upgrade Python...\n"

	# Try to upgrade
	case "$CURRENT_OS" in
	macos)
		brew upgrade python@3
		;;
	fedora | oracle | rocky)
		sudo dnf upgrade -y python3
		;;
	ubuntu | rpi)
		sudo apt update && sudo apt upgrade -y python3
		;;
	arch)
		sudo pacman -S --noconfirm python
		;;
	*)
		printf "%bERROR: Please upgrade Python manually%b\n" "$RED" "$NC"
		exit 1
		;;
	esac

	# Recheck after upgrade attempt
	PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
	PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
	PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

	if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 6 ]; }; then
		printf "%bERROR: Still using Python %s. Please upgrade manually.%b\n" "$RED" "$PYTHON_VERSION" "$NC"
		exit 1
	fi
fi

# Run the Python installer
printf "%b✓ Python %s detected%b\n" "$GREEN" "$PYTHON_VERSION" "$NC"
printf "%bStarting interactive installer...%b\n\n" "$GREEN" "$NC"
exec "$PYTHON_CMD" "$SCRIPT_DIR/install/install.py" "$@"
