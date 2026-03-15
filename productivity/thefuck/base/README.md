# The Fuck - Corrects Your Previous Command

The Fuck is a magnificent app that corrects errors in previous console commands. It's like autocorrect for your terminal.

## Features

### Core Features
- **Auto-Correction** - Fixes common command mistakes
- **Rule-Based** - Hundreds of built-in rules
- **Smart Detection** - Analyzes error messages
- **Confirmation** - Shows correction before running
- **Customizable** - Create your own rules
- **Shell Integration** - Works with bash, zsh, fish, etc.
- **Fast** - Written in Python, very responsive

### Common Corrections
- Missing `sudo`
- Typo in command name
- Wrong command arguments
- Missing dashes/hyphens
- Git command mistakes
- Package manager errors
- File permission errors
- Path errors

## Installation

### Prerequisites

```bash
# Install The Fuck
# macOS
brew install thefuck

# Fedora
sudo dnf install thefuck

# Ubuntu
sudo apt install thefuck

# Arch
sudo pacman -S thefuck

# Gentoo
sudo emerge app-admin/thefuck

# Void
sudo xbps-install thefuck

# Alpine
sudo apk add thefuck

# FreeBSD
sudo pkg install thefuck

# Windows (11)
# Use WSL or install via Python:
pip install thefuck

# Python (any OS)
pip install thefuck
```

### Setup

```bash
# Add to shell configuration
# See below for shell-specific instructions

# Test installation
fuck
```

## Shell Integration

### Zsh

Add to `~/.config/zsh/base/.zshrc`:

```bash
# The Fuck initialization
eval "$(thefuck --alias fuck)"

# Or use shorter alias
eval "$(thefuck --alias f)"
```

### Bash

Add to `~/.bashrc`:

```bash
# The Fuck initialization
eval "$(thefuck --alias fuck)"

# Or use shorter alias
eval "$(thefuck --alias f)"
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
# The Fuck initialization
thefuck --alias fuck | source

# Or use shorter alias
thefuck --alias f | source
```

## Usage

### Basic Usage

```bash
# Make a mistake
$ apt install vim
E: Could not open lock file /var/lib/dpkg/lock-frontend

# Correct it with fuck
$ fuck
sudo apt install vim [enter/↑/↓/ctrl+c]
[enter] to run: sudo apt install vim
```

### Shorter Alias

```bash
# Use 'f' instead of 'fuck'
$ apt install vim
$ f
sudo apt install vim
```

### Interactive Mode

```bash
# The Fuck shows suggestions
# Press enter to run first suggestion
# Use arrow keys to select different suggestion
# Press ctrl+c to cancel
```

### Without Confirmation

```bash
# Run first suggestion immediately (not recommended)
fuck --yeah

# Or with alias
f --yeah
```

### Debug Mode

```bash
# Show debug information
fuck --debug

# Show rules being applied
fuck --debug --verbose
```

## Built-in Rules

The Fuck includes hundreds of rules for common mistakes:

### Git
```bash
$ git brnach
git branch

$ git push
fatal: The current branch master has no upstream branch.
$ fuck
git push -u origin master
```

### Package Managers
```bash
$ apt install vim
E: Could not open lock file
$ fuck
sudo apt install vim

$ brew install python
Error: No available formula with the name "python"
$ fuck
brew install python@3
```

### Docker
```bash
$ docker ps -a
Got permission denied while trying to connect to the Docker daemon
$ fuck
sudo docker ps -a

# Or better:
$ fuck
docker ps -a
# Add user to docker group instead!
```

### npm
```bash
$ npm install
npm ERR! missing script: install
$ fuck
npm ci

$ npm run serv
npm ERR! missing script: serv
$ fuck
npm run serve
```

### Python
```bash
$ python script.py
python: can't open file 'script.py': [Errno 2] No such file or directory
$ fuck
python ./script.py
```

### Common Mistakes
```bash
$ ls -l .txt
ls: cannot access '.txt': No such file or directory
$ fuck
ls -l *.txt

$ cat file.txt | grep "test"
$ fuck
grep "test" file.txt

$ curl http://example.com
$ fuck
curl https://example.com
```

## Configuration

### config.toml

```toml
# Location: ~/.config/thefuck/config.toml

# Require confirmation before running (recommended)
require_confirmation = true

# Wait time before running command (seconds)
wait_command = 3

# No wait for certain commands
no_wait = ["git", "ls", "cat"]

# Exclude specific rules
exclude_rules = [
  "git_fix_stash",
  "svn_merge",
]

# Enable debug mode
debug = false

# Alter shell history (replace old command)
alter_history = true

# Number of commands to remember
history_limit = 1000
```

### Custom Rules

```python
# Location: ~/.config/thefuck/rules/

# Example: Fix common Python typo
# File: python_typo.py

from thefuck.shells import shell
from thefuck.utils import for_app

@for_app('python')
def match(command, settings):
    return ('python' in command.script and
            'python' in command.output and
            'pyhton' in command.script)

def get_new_command(command):
    return command.script.replace('pyhton', 'python')
```

### Priority

```toml
# Set priority for specific commands
# Lower number = higher priority

[priority]
# Git commands have highest priority
"^git" = 100

# Package managers
"^apt" = 75
"^yum" = 75
"^brew" = 75

# npm commands
"^npm" = 50
```

## Practical Examples

### Daily Development

```bash
# Forgot sudo
$ apt update
$ fuck

# Typo in command
$ grco master
$ fuck

# Wrong argument
$ git pull origin
$ fuck
# Changes to: git pull

# Missing cd
$ documents
$ fuck
cd documents
```

### Container Management

```bash
# Docker needs sudo
$ docker ps
$ fuck
sudo docker ps

# Typo in docker-compose
$ docker-compose up
$ fuck
docker compose up
```

### Server Administration

```bash
# systemctl needs sudo
$ systemctl restart nginx
$ fuck

# Wrong service name
$ systemctl restart ngin
$ fuck
systemctl restart nginx
```

### Web Development

```bash
# npm script typo
$ npm run bild
$ fuck
npm run build

# Missing yarn
$ yarn install
$ fuck
npm install
```

## Tips

### Safety

```bash
# Always require confirmation
require_confirmation = true

# Review before running
# Read the suggestion before pressing enter

# Test in safe environment first
# Try fuck in non-critical environments
```

### Productivity

```bash
# Use shorter alias
eval "$(thefuck --alias f)"

# Add to shell for immediate use
# Put at end of shell config

# Learn from mistakes
# Pay attention to corrections
```

### Customization

```bash
# Create custom rules for your workflow
# Common typos, specific project commands

# Exclude rules you don't use
exclude_rules = ["git_fix_stash"]

# Set priority for your commands
[priority]
"^myapp" = 200  # Highest priority
```

### Shell History

```bash
# Enable history alteration
alter_history = true

# This replaces the wrong command with the corrected one
# Your history looks clean!
```

## Aliases

Add to shell config:

```bash
# Standard alias (already set)
eval "$(thefuck --alias fuck)"

# Shorter alias
eval "$(thefuck --alias f)"

# Or manually:
alias fuck='thefuck'
alias f='thefuck'
```

## Troubleshooting

### "Command not found: fuck"

```bash
# Check shell integration
grep "thefuck" ~/.bashrc
grep "thefuck" ~/.zshrc

# Reload shell
exec $SHELL

# Add manually
eval "$(thefuck --alias fuck)"
```

### No suggestions shown

```bash
# Check debug mode
fuck --debug

# Check if rule exists
fuck --debug --verbose

# Report issue if bug
https://github.com/nvbn/thefuck/issues
```

### Always runs first suggestion

```bash
# Check if confirmation is enabled
grep require_confirmation ~/.config/thefuck/config.toml

# Enable confirmation
require_confirmation = true
```

### Custom rule not working

```bash
# Check rule file location
ls -l ~/.config/thefuck/rules/

# Check rule syntax
python -m py_compile ~/.config/thefuck/rules/myrule.py

# Test rule
fuck --debug
```

## Comparison

**The Fuck:**
- Python-based
- Hundreds of rules
- Shell integration
- Highly configurable
- Active development
- Large community

**thefuck (original):**
- First of its kind
- Most mature
- Most rules
- Best documentation
- Most users

**cli-magic:**
- Node.js based
- Fewer features
- Less mature
- Similar concept
- Less popular

**autocorrect:**
- Fish shell only
- Built into fish
- Simpler
- Less powerful
- Fish-specific

## Advanced Usage

### Custom Rules

```python
# Create custom rule
# File: ~/.config/thefuck/rules/myproject.py

from thefuck.shells import shell

def match(command):
    return 'myapp' in command.script and 'error' in command.output

def get_new_command(command):
    return command.script.replace('myapp', 'myapp --fix')

# Test rule
fuck --debug
```

### Shell Scripts

```bash
# Use in scripts
if ! mycommand; then
    fuck --yeah
fi
```

### Automation

```bash
# Automatically correct without confirmation
# Use with caution!
alias f='fuck --yeah'

# Or set in config
require_confirmation = false
```

## Resources

- [The Fuck Website](https://thefuck.dev)
- [The Fuck GitHub](https://github.com/nvbn/thefuck)
- [The Fuck Documentation](https://github.com/nvbn/thefuck#readme)
- [Available Rules](https://github.com/nvbn/thefuck#rules)

---

**Last Updated**: 2025-03-14
