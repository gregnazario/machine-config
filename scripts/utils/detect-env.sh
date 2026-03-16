#!/bin/sh
# Environment Detection Script
# Detects: sudo availability, containers, WSL, OrbStack, etc.

# Output format: KEY=VALUE (one per line)

# Check if running as root
is_root() {
	[ "$(id -u)" -eq 0 ]
}

# Check if sudo is available
has_sudo() {
	command -v sudo >/dev/null 2>&1
}

# Check if we can use sudo (either root or sudo works)
can_sudo() {
	if is_root; then
		return 0
	elif has_sudo; then
		# Test if sudo works (might not need password)
		sudo -n true 2>/dev/null && return 0
	fi
	return 1
}

# Detect container type
detect_container() {
	# Check for Docker
	if [ -f /.dockerenv ]; then
		echo "docker"
		return 0
	fi

	# Check for container in cgroup
	if [ -f /proc/1/cgroup ]; then
		case "$(cat /proc/1/cgroup 2>/dev/null)" in
			*docker*|*containerd*)
				echo "docker"
				return 0
				;;
			*lxc*|*lxd*)
				echo "lxc"
				return 0
				;;
			*kubepods*)
				echo "kubernetes"
				return 0
				;;
		esac
	fi

	# Check for podman
	if [ -f /run/.containerenv ]; then
		echo "podman"
		return 0
	fi

	# Check for OrbStack
	if [ -d /OrbStack ] || [ -f /proc/orbstack ]; then
		echo "orbstack"
		return 0
	fi

	# Check for WSL
	if [ -f /proc/version ] && grep -qi microsoft /proc/version; then
		echo "wsl"
		return 0
	fi

	# Not a container (or couldn't detect)
	echo "none"
	return 0
}

# Detect WSL version (if in WSL)
detect_wsl_version() {
	if [ -f /proc/version ]; then
		case "$(cat /proc/version)" in
			*Microsoft*)
				echo "1"
				return 0
				;;
			*microsoft-standard-WSL2*)
				echo "2"
				return 0
				;;
		esac
	fi
	echo "0"
}

# Main output
echo "IS_ROOT=$(is_root && echo 'true' || echo 'false')"
echo "HAS_SUDO=$(has_sudo && echo 'true' || echo 'false')"
echo "CAN_SUDO=$(can_sudo && echo 'true' || echo 'false')"
echo "CONTAINER_TYPE=$(detect_container)"
echo "WSL_VERSION=$(detect_wsl_version)"

# Additional info
if [ -n "${CONTAINER_TYPE:-}" ] && [ "$CONTAINER_TYPE" != "none" ]; then
	echo "IN_CONTAINER=true"
else
	echo "IN_CONTAINER=false"
fi

if [ -n "${WSL_VERSION}" ] && [ "$WSL_VERSION" != "0" ]; then
	echo "IN_WSL=true"
else
	echo "IN_WSL=false"
fi
