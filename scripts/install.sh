#!/bin/sh
# Bootstrap installer - Checks for Python 3 and runs the main installer
# POSIX-compliant

set -e -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

if [ -z "$PYTHON_CMD" ]; then
    printf "%bERROR: Python 3 is not installed%b\n" "$RED" "$NC"
    printf "\nTo install Python 3:\n"
    printf "  macOS:   brew install python@3\n"
    printf "  Fedora:  sudo dnf install python3\n"
    printf "  Ubuntu:  sudo apt install python3\n"
    printf "  Arch:    sudo pacman -S python\n"
    printf "\nPython 3 is required to run the interactive installer.\n"
    exit 1
fi

# Check Python version (need 3.6+)
PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 6 ]; }; then
    printf "%bERROR: Python 3.6 or higher is required%b\n" "$RED" "$NC"
    printf "You have Python %s\n" "$PYTHON_VERSION"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run the Python installer
printf "%bStarting interactive installer...%b\n\n" "$GREEN" "$NC"
exec "$PYTHON_CMD" "$SCRIPT_DIR/install/install.py" "$@"
