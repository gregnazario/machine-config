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

# Default values
SKIP_PYTHON_CHECK=""
AUTO_INSTALL_PYTHON=""
USE_TUI=""

# Parse arguments
while [ $# -gt 0 ]; do
	case "$1" in
	--help | -h)
		printf "Usage: %s [OPTIONS]\n" "$0"
		printf "\n"
		printf "Options:\n"
		printf "  --help, -h                Show this help message\n"
		printf "  --profile <name>          Select installation profile (minimal, developer,\n"
		printf "                            terminal-ninja, sysadmin, full)\n"
		printf "  --tools <tool1,tool2>     Comma-separated list of tools to install\n"
		printf "  --categories <cat1,cat2>   Comma-separated list of categories to install\n"
		printf "  --yes, -y                 Auto-accept all prompts\n"
		printf "  --dry-run                 Show what would be installed without installing\n"
		printf "  --tui                     Use terminal UI with mouse support\n"
		printf "  --skip-python-check       Skip Python version check\n"
		printf "  --no-python-install       Don't install Python automatically\n"
		printf "\n"
		printf "Profiles:\n"
		printf "  minimal         Essential tools for everyday use (4 tools)\n"
		printf "  developer       Full development environment (~20 tools)\n"
		printf "  terminal-ninja  Terminal productivity focus (~25 tools)\n"
		printf "  sysadmin        Server management tools (~15 tools)\n"
		printf "  full            All available tools\n"
		printf "\n"
		printf "Examples:\n"
		printf "  %s --profile minimal\n" "$0"
		printf "  %s --tools zsh,neovim,git\n" "$0"
		printf "  %s --categories shells,editors --yes\n" "$0"
		exit 0
		;;
	--skip-python-check)
		SKIP_PYTHON_CHECK="--skip-python-check"
		shift
		;;
	--no-python-install)
		AUTO_INSTALL_PYTHON="--no-python-install"
		shift
		;;
	--tui)
		USE_TUI="--tui"
		shift
		;;
	*)
		# Pass all other arguments to Python installer
		break
		;;
	esac
done

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
	fedora | oracle | rocky | almalinux)
		sudo dnf install -y python3 python3-pip
		;;
	amazon)
		if command -v yum >/dev/null 2>&1; then
			sudo yum install -y python3 python3-pip
		elif command -v dnf >/dev/null 2>&1; then
			sudo dnf install -y python3 python3-pip
		fi
		;;
	ubuntu | debian | rpi | mint)
		sudo apt update
		sudo apt install -y python3 python3-pip
		;;
	arch)
		sudo pacman -S --noconfirm python python-pip
		;;
	opensuse)
		sudo zypper install -y python3 python3-pip
		;;
	solus)
		sudo eopkg install -y python3 python3-pip
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
	openbsd)
		sudo pkg_add python%python3
		;;
	netbsd)
		sudo pkgin install python3
		;;
	nixos)
		printf "%bPlease add Python to /etc/nixos/configuration.nix:%b\n" "$YELLOW" "$NC"
		printf "  environment.systemPackages = [ python3 ]\n"
		return 1
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

	# Check if --no-python-install flag was given
	if [ "$AUTO_INSTALL_PYTHON" = "--no-python-install" ]; then
		printf "%b--no-python-install flag specified.%b\n" "$YELLOW" "$NC"
		printf "Please install Python 3 manually and run this script again.\n\n"
		printf "Installation instructions:\n"
		printf "  macOS:   brew install python@3\n"
		printf "  Fedora:  sudo dnf install python3\n"
		printf "  Ubuntu:  sudo apt install python3\n"
		printf "  Arch:    sudo pacman -S python\n"
		exit 1
	fi

	printf "Python 3 is not installed. The installer can install it for you.\n\n"

	# Ask for permission
	while true; do
		printf "%b→ Install Python 3 automatically? [y/N]: %b" "$YELLOW" "$NC"
		read -r response
		case "$response" in
		[Yy] | [Yy][Ee][Ss])
			# Try to install automatically
			if install_python "$CURRENT_OS"; then
				PYTHON_CMD="python3"
			else
				printf "\n%bERROR: Python 3 installation failed%b\n" "$RED" "$NC"
				printf "\nPlease install Python 3 manually and run this script again.\n"
				exit 1
			fi
			break
			;;
		[Nn] | [Nn][Oo] | "")
			printf "\nPlease install Python 3 manually and run this script again.\n\n"
			printf "Installation instructions:\n"
			printf "  macOS:   brew install python@3\n"
			printf "  Fedora:  sudo dnf install python3\n"
			printf "  Ubuntu:  sudo apt install python3\n"
			printf "  Arch:    sudo pacman -S python\n"
			exit 0
			;;
		*)
			printf "Please answer yes or no\n"
			;;
		esac
	done
fi

# Check Python version (need 3.6+)
if [ "$SKIP_PYTHON_CHECK" != "--skip-python-check" ]; then
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
		fedora | oracle | rocky | almalinux)
			sudo dnf upgrade -y python3
			;;
		amazon)
			if command -v yum >/dev/null 2>&1; then
				sudo yum upgrade -y python3
			elif command -v dnf >/dev/null 2>&1; then
				sudo dnf upgrade -y python3
			fi
			;;
		ubuntu | debian | rpi | mint)
			sudo apt update && sudo apt upgrade -y python3
			;;
		arch)
			sudo pacman -S --noconfirm python
			;;
		opensuse)
			sudo zypper update -y python3
			;;
		solus)
			sudo eopkg upgrade python3
			;;
		freebsd | openbsd | netbsd | nixos | void | gentoo | alpine)
			printf "%bPlease upgrade Python manually on %s%b\n" "$YELLOW" "$CURRENT_OS" "$NC"
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
fi

# Run the Python installer
printf "%b✓ Python %s detected%b\n" "$GREEN" "$PYTHON_VERSION" "$NC"

# Check if TUI mode is requested
if [ "$USE_TUI" = "--tui" ]; then
	printf "%bStarting TUI installer...%b\n\n" "$GREEN" "$NC"
	exec "$PYTHON_CMD" "$SCRIPT_DIR/install/install.py" "--tui" "$@"
else
	printf "%bStarting interactive installer...%b\n\n" "$GREEN" "$NC"
	exec "$PYTHON_CMD" "$SCRIPT_DIR/install/install.py" "$@"
fi
