# Fish Shell Configuration
# Base configuration for all operating systems
# Pure Fish - no framework

# === Starship Prompt ===
# Initialize Starship prompt
if command -q starship
    starship init fish | source
end

# === Path Configuration ===
# Add user bin directories to PATH
fish_add_path --path --move $HOME/.local/bin
fish_add_path --path --move $HOME/bin

# === History Configuration ===
# Store more history
set -g fish_history_max_items 10000

# Don't store duplicate entries
set -g fish_history_ignore_duplicates true

# === Abbreviations (Fish's modern aliases) ===
# Safer core utilities
abbr --add ls 'ls --color=auto --group-directories-first -F'
abbr --add ll 'ls -lh --color=auto'
abbr --add la 'ls -lha --color=auto'
abbr --add lt 'ls -lht --color=auto'
abbr --add rm 'rm -iv'
abbr --add cp 'cp -iv'
abbr --add mv 'mv -iv'

# Modern replacements
if command -q exa
    abbr --add ls 'exa --group-directories-first --git'
    abbr --add ll 'exa -lh --group-directories-first --git'
    abbr --add la 'exa -lha --group-directories-first --git'
    abbr --add lt 'exa --long --sort=modified --group-directories-first --git'
end

if command -q bat
    abbr --add cat 'bat --paging=never'
end

if command -q btop
    abbr --add top 'btop'
else if command -q htop
    abbr --add top 'htop'
end

# Git abbreviations
abbr --add gst 'git status'
abbr --add gco 'git checkout'
abbr --add gbr 'git branch'
abbr --add glog 'git log --oneline --graph --decorate'
abbr --add gadd 'git add'
abbr --add gcom 'git commit'
abbr --add gpush 'git push'
abbr --add gpull 'git pull'
abbr --add gdiff 'git diff'
abbr --add gmerge 'git merge'
abbr --add grebase 'git rebase'
abbr --add greset 'git reset'
abbr --add gundo 'git reset --soft HEAD~1'
abbr --add glast 'git log -1 --stat'

# Directory navigation
abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add ..... 'cd ../../../..'

# === Directory Hashes ===
# Quick access to common directories
set -g projects_dir $HOME/projects
set -g work_dir $HOME/work
set -g dotfiles_dir $HOME/.local/share/greg-config

function cd
    # Override cd to support directory hashes
    builtin cd $argv
end

# === FZF Integration ===
if command -q fzf
    # FZF default options
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --preview "bat --color=always {}" --preview-window=right:60%:wrap'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude node_modules'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # FZF key bindings
    if test -f /usr/share/fzf/key-bindings.fish
        source /usr/share/fzf/key-bindings.fish
    else if test -f /usr/local/opt/fzf/shell/key-bindings.fish
        source /usr/local/opt/fzf/shell/key-bindings.fish
    end
end

# === Direnv ===
if command -q direnv
    direnv hook fish | source
end

# === Editor ===
# Set default editor
if set -q EDITOR
    # EDITOR is already set
else if command -q nvim
    set -gx EDITOR nvim
else if command -q vim
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end

# === PAGER ===
# Use less with useful options
if command -q bat
    set -gx PAGER 'bat'
else if command -q less
    set -gx PAGER 'less -FR'
end

# === Language-specific ===

# Python
set -gx PYTHONIOENCODING utf-8
if command -q pyenv
    pyenv init - | source
end

# Node.js
if command -q fnm
    fnm env | source
end

# Rust
set -gx CARGO_HOME $HOME/.cargo
fish_add_path --path $CARGO_HOME/bin

# Go
set -gx GOPATH $HOME/go
fish_add_path --path $GOPATH/bin

# === Colors ===
# Enable 24-bit color
set -gx COLORTERM truecolor
set -gx TERM xterm-256color

# === Local Overrides ===
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

# === Welcome Message ===
# Show a brief greeting when shell starts (optional)
function fish_greeting
    # Uncomment to show greeting
    # echo "Welcome to Fish, "(whoami)"@"
    # uname -nrs
end
