# Zoxide Configuration
# This file is sourced by zoxide when it initializes

# === Basic Settings ===

# Database path (default: ~/.local/share/zoxide/db)
# Uncomment to customize:
# _ZO_DATA_DIR="$HOME/.local/share/zoxide"

# Maximum number of entries (default: 10000)
# Uncomment to customize:
# _ZO_MAXAGE=10000

# Resolve symlinks (default: false)
# Uncomment to enable:
# _ZO_RESOLVE_SYMLINKS=1

# === Priority Settings ===

# Priority calculation method
# Options:
# - "recent" - Recency only (default)
# - "frequent" - Frequency only
# - "recent,frequent" - Mixed (recommended)
# _ZO_PRIORITIZE="recent,frequent"

# === Exclusions ===

# Exclude directories from database
# Add directories to exclude:
# _ZO_EXCLUDE_DIRS="$HOME:$HOME/old"

# === Auto Add ===

# Automatically add directories to database (default: true)
# _ZO_AUTO_ADD=1

# === Echo ===

# Echo directory after cd (default: false)
# _ZO_ECHO=1

# === Commands ===

# Define zoxide command (default: z)
# _ZO_CMD="z"

# Define zoxide query command (default: zi)
# _ZO_FZF_CMD="zi"

# === FZF Integration ===

# Enable fzf integration (if fzf is installed)
# _ZO_FZF_OPTS="--preview 'ls -la {}'"

# === Path Customization ===

# Define paths to include in database
# _ZO_DATA_DIR="$HOME/.local/share/zoxide"
