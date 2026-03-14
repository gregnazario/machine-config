# Direnv - Directory-Specific Environment Variables

Direnv is an extension for your shell that loads and unloads environment variables depending on the current directory. It helps you keep your project-specific configuration separate from your shell configuration.

## Features

### Core Features
- **Auto-Loading** - Automatically loads .envrc when entering directory
- **Auto-Unloading** - Unloads when leaving directory
- **Multiple Shells** - Works with bash, zsh, fish, nushell
- **Safety** - Requires approval before loading new .envrc
- **Fast** - Written in Go, very fast
- **Layout Detection** - Auto-detects project types (Node, Python, Ruby, Go)
- **Watch Files** - Reloads when watched files change
- **Clean** - No leftover environment variables

### Use Cases
- Project-specific environment variables
- Automatic PATH modifications
- Virtualenv activation
- Node version switching
- Development environment setup
- Temporary environment changes
- Secret management (with .env files)

## Installation

### Prerequisites

```bash
# Install Direnv
# macOS
brew install direnv

# Fedora
sudo dnf install direnv

# Ubuntu
sudo apt install direnv

# Arch
sudo pacman -S direnv

# Gentoo
sudo emerge app-shells/direnv

# Void
sudo xbps-install direnv

# Alpine
sudo apk add direnv

# FreeBSD
sudo pkg install direnv

# Windows (11)
# Use WSL
# Or download binary from GitHub

# Cargo (Rust)
cargo install direnv
```

### Setup

```bash
# Add to shell configuration
# See below for shell-specific instructions

# Hook into shell
eval "$(direnv hook bash)"    # For Bash
eval "$(direnv hook zsh)"     # For Zsh
direnv hook fish | source     # For Fish
```

## Shell Integration

### Zsh

Add to `~/.config/zsh/base/.zshrc`:

```bash
# Direnv hook (must be after prompt setup)
eval "$(direnv hook zsh)"
```

### Bash

Add to `~/.bashrc`:

```bash
# Direnv hook
eval "$(direnv hook bash)"
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
# Direnv hook
direnv hook fish | source
```

### Nushell

Add to `~/.config/nushell/env.nu`:

```nu
# Direnv hook (experimental)
# Requires direnv nushell plugin
```

## Usage

### Basic Usage

```bash
# Create .envrc file
echo 'export HELLO=world' > .envrc

# Enter directory (direnv will ask for permission)
cd myproject/

# Allow .envrc
direnv allow

# Now HELLO environment variable is set
echo $HELLO  # => "world"

# Leave directory (environment variables are unset)
cd ..

# Revoke .envrc
direnv deny
```

### Creating .envrc Files

```bash
# Simple .envrc
export PROJECT_NAME=myproject
export DATABASE_URL=postgresql://localhost/myproject
export API_KEY=secret_key_here

# Add to PATH
PATH_add bin

# Load from .env file
dotenv .env

# Watch file for changes
watch_file package.json
```

### Project Layouts

#### Node.js Project

```bash
# .envrc
layout node
watch_file package.json
PATH_add node_modules/.bin

# Or use specific node version
layout node
```

#### Python Project

```bash
# .envrc
layout python
watch_file requirements.txt

# Or specific python version
layout python3.11
```

#### Ruby Project

```bash
# .envrc
layout ruby
watch_file Gemfile
```

#### Go Project

```bash
# .envrc
layout go
watch_file go.mod
```

#### Rust Project

```bash
# .envrc
# Rust doesn't need layout
watch_file Cargo.toml
PATH_add target/debug
```

#### Mixed Project

```bash
# .envrc (Node.js + Python)
layout node
layout python3
PATH_add node_modules/.bin
watch_file package.json
watch_file requirements.txt
```

### Directory Commands

```bash
# Allow .envrc in current directory
direnv allow

# Deny .envrc
direnv deny

# Reload .envrc
direnv reload

# Edit .envrc
direnv edit

# Show current status
direnv status

# Show loaded environment variables
direnv export <shell>

# Show version
direnv version
```

## Configuration

### Global Config

```bash
# Location: ~/.config/direnv/direnv.toml

[global]
# Disable warnings
warn_timeout = "0s"

# Whitelist prefixes
whitelist = {}

# Strict mode
strict_env = false
```

### .envrc File

```bash
# .envrc example

# Simple exports
export PROJECT_NAME=myproject
export DATABASE_URL=postgresql://localhost/myproject

# Add to PATH
PATH_add bin
PATH_add scripts

# Load from .env file
dotenv .env

# Load from .env.local if exists
dotenv_if_exists .env.local

# Watch files
watch_file package.json
watch_file requirements.txt

# Use layout
layout node
```

### Layouts

```bash
# Node.js layout
layout node

# Python layout (detects .python-version)
layout python

# Python 3.11
layout python3.11

# Ruby layout
layout ruby

# Go layout
layout go

# Perl layout
layout perl

# Java layout
layout java
```

### Utilities

```bash
# Add directory to PATH
PATH_add bin

# Add directory to end of PATH
PATH_rm bin

# Load environment file
dotenv .env

# Load environment file if exists
dotenv_if_exists .env.local

# Watch file for changes
watch_file file.txt

# Load module
load_prefix /usr/local

# Define function
my_function() {
  echo "Custom function"
}
```

## Practical Examples

### Web Development

```bash
# .envrc for web project
export NODE_ENV=development
export DATABASE_URL=postgresql://localhost/dev
export REDIS_URL=redis://localhost/6379

# Load from .env
dotenv .env

# Node.js layout
layout node
PATH_add node_modules/.bin

# Watch package.json
watch_file package.json
```

### Data Science

```bash
# .envrc for Python data project
export PYTHONPATH=$PWD/src
export JUPYTER_PATH=$PWD/notebooks

# Python virtualenv
layout python

# Watch dependencies
watch_file requirements.txt
watch_file environment.yml
```

### Microservices

```bash
# .envrc for microservice
export SERVICE_NAME=user-service
export PORT=3000
export DATABASE_URL=postgresql://localhost/user_service

# Node.js
layout node

# Load secrets if exists
dotenv_if_exists .env.secrets
```

### Multi-Language Project

```bash
# .envrc for monorepo
export PROJECT_ROOT=$PWD

# Backend (Python)
export PYTHONPATH=$PWD/backend/src
layout python3

# Frontend (Node.js)
export PATH=$PWD/frontend/node_modules/.bin:$PATH
layout node

# Watch both
watch_file backend/requirements.txt
watch_file frontend/package.json
```

## Tips

### Security

```bash
# Don't commit secrets
# Add to .gitignore:
.env
.env.local
.envrc

# Use .env.example
cp .env.example .env
direnv allow

# Never commit .envrc with secrets
git rm --cached .envrc
```

### Performance

```bash
# Only load when needed
watch_file package.json

# Use lazy loading
layout node  # Only activates when needed

# Minimize exports
# Only export what you need
```

### Development

```bash
# Test .envrc without reloading
direnv edit

# Reload after changes
direnv reload

# Check status
direnv status

# Show what will be loaded
direnv export bash
```

### Team Workflow

```bash
# Commit .envrc.example
cat > .envrc.example << 'EOF'
export PROJECT_NAME=myproject
export DATABASE_URL=postgresql://localhost/myproject

# Copy and customize
# cp .envrc.example .envrc
EOF

# Developers create their own .envrc
cp .envrc.example .envrc
# Edit and customize
direnv allow
```

## Aliases

Add to shell config:

```bash
# Direnv aliases
alias da='direnv allow'      # Allow .envrc
alias dd='direnv deny'       # Deny .envrc
alias dr='direnv reload'     # Reload .envrc
alias ds='direnv status'     # Show status
alias de='direnv edit'       # Edit .envrc
```

## Troubleshooting

### "direnv: error .envrc is blocked"

```bash
# Allow the .envrc
direnv allow

# Or allow globally (not recommended)
# Add to .gitignore if you want
```

### Environment variables not loading

```bash
# Check .envrc syntax
direnv edit

# Reload shell
exec $SHELL

# Check status
direnv status

# Manually reload
direnv reload
```

### Wrong directory

```bash
# Check current directory
pwd

# Check .envrc location
ls -la .envrc

# Check if parent has .envrc
# Direnv loads all .envrc in path
```

### Hook not working

```bash
# Check if hook is loaded
echo $PROMPT_COMMAND | grep direnv  # Bash
echo $preexec_functions | grep direnv  # Zsh

# Check shell config
grep "direnv hook" ~/.bashrc
grep "direnv hook" ~/.zshrc

# Reload shell
exec $SHELL
```

## Comparison

**Direnv:**
- Shell-agnostic
- Fast (Go)
- Auto-load/unload
- Safety features
- Layout detection
- Watch files

**dotenv:**
- Simple
- No auto-load
- Shell-specific
- Manual loading
- No safety
- No watches

**autoenv:**
- Similar to direnv
- Less safe
- Python-based
- Slower
- Fewer features

**pyenv/virtualenv:**
- Python-specific
- Not directory-aware
- Manual activation
- No environment variables

**nvm:**
- Node-specific
- Manual activation
- No environment variables
- Shell-specific

## Advanced Usage

### Custom Functions

```bash
# .envrc
# Define custom function
load_secrets() {
  if [ -f .env.secrets ]; then
    dotenv .env.secrets
  fi
}

# Call function
load_secrets
```

### Conditional Loading

```bash
# .envrc
# Load different config based on hostname
if [ "$(hostname)" = "workstation" ]; then
  export ENV=development
else
  export ENV=production
fi
```

### Nested Directories

```bash
# Parent .envrc
export PROJECT_ROOT=$PWD

# Child .envrc (in subdirectory)
export SERVICE_NAME=user-service
# Inherits PROJECT_ROOT from parent
```

### Watch Multiple Files

```bash
# .envrc
watch_file package.json
watch_file tsconfig.json
watch_file .env
```

## Resources

- [Direnv Website](https://direnv.net)
- [Direnv GitHub](https://github.com/direnv/direnv)
- [Direnv Documentation](https://direnv.net/docs/hook.html)
- [Direnv Man Page](https://direnv.net/man/direnv.1.html)

---

**Last Updated**: 2025-03-14
