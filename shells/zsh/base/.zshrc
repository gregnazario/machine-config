# ZSH Configuration
# Base configuration for all operating systems
# This file is sourced first, then OS-specific overrides are applied

# === Path Configuration ===
# Add user bin directories to PATH
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$path[@]"
)

# === History Configuration ===
# Store more history, share across sessions
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_SPACE      # Ignore entries starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt EXTENDED_HISTORY       # Write timestamps to history
setopt INC_APPEND_HISTORY     # Write to history immediately

# === Completion System ===
# Use modern completion system
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-${ZSH_VERSION}

# Completion options
setopt AUTO_MENU              # Show completion menu on successive tab presses
setopt COMPLETE_IN_WORD       # Complete from both ends of a word
setopt ALWAYS_TO_END          # Move cursor to end of word on completion
setopt LIST_PACKED            # Pack completions tightly
setopt LIST_TYPES             # Show types in completion lists

# === Key Bindings ===
# Use vim-style key bindings
bindkey -v
bindkey "^R" history-incremental-search-backward
bindkey "^?" backward-delete-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Better history search with Up/Down arrows
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# === Directory Navigation ===
setopt AUTO_CD                # Auto cd to typed directory
setopt AUTO_PUSHD             # Push old directory onto stack
setopt PUSHD_IGNORE_DUPS      # Don't push duplicates
setopt PUSHD_SILENCE          # Don't print stack after pushd/popd

# Directory aliases for common projects
hash -d projects=$HOME/projects
hash -d work=$HOME/work
hash -d dotfiles=$HOME/.local/share/greg-config

# === Safe Core Utilities ===
# Safer versions of common commands with better defaults

# Colorized and safer ls
if command -v dircolors >/dev/null; then
    eval "$(dircolors -b ~/.config/shell/dircolors)"
fi

alias ls='ls --color=auto --group-directories-first -F'
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias lt='ls -lht --color=auto'  # Sort by time

# Safety aliases for destructive commands
alias rm='rm -iv'                # Interactive delete
alias cp='cp -iv'                # Interactive copy
alias mv='mv -iv'                # Interactive move

# Better defaults for common commands
alias grep='grep --color=auto --directories=skip'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# === Modern Replacements ===
# Use modern replacements when available

# exa/lsd → modern ls replacements
if command -v exa >/dev/null; then
    alias ls='exa --group-directories-first --git'
    alias ll='exa -lh --group-directories-first --git'
    alias la='exa -lha --group-directories-first --git'
    alias lt='exa --long --sort=modified --group-directories-first --git'
elif command -v lsd >/dev/null; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd -lh'
    alias la='lsd -lha'
    alias lt='lsd --sort=time'
fi

# bat → modern cat with syntax highlighting
if command -v bat >/dev/null; then
    alias cat='bat --paging=never'
fi

# ripgrep → modern grep
if command -v rg >/dev/null; then
    alias grep='rg --color=auto'
    alias egrep='rg --color=auto'
fi

# fd → modern find
if command -v fd >/dev/null; then
    # Keep find as find, but add f alias
    alias f='fd'
fi

# dust/du-dust → modern du
if command -v dust >/dev/null; then
    alias du='dust'
fi

# htop/btop → modern top
if command -v btop >/dev/null; then
    alias top='btop'
elif command -v htop >/dev/null; then
    alias top='htop'
fi

# === Git Shortcuts ===
# Semantic git aliases
alias gst='git status'
alias gco='git checkout'
alias gbr='git branch'
alias glog='git log --oneline --graph --decorate'
alias gadd='git add'
alias gcom='git commit'
alias gpush='git push'
alias gpull='git pull'
alias gdiff='git diff'
alias gmerge='git merge'
alias grebase='git rebase'
alias greset='git reset'

# git undo (soft reset)
alias gundo='git reset --soft HEAD~1'

# git last (show last commit)
alias glast='git log -1 --stat'

# === Other Useful Aliases ===
# Quick edit configs
alias zshrc='${EDITOR:-vim} ~/.config/zsh/.zshrc'
alias starship='${EDITOR:-vim} ~/.config/starship.toml'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Clear with useful message
alias c='clear'
alias cl='clear && printf "\033[3J"'  # Clear scrollback too

# Disk usage and system info
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Make parent directories as needed
alias mkdir='mkdir -p'

# === Starship Prompt ===
# Initialize Starship prompt
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
fi

# === FZF Integration ===
# Setup fzf key bindings and fuzzy completion
if command -v fzf >/dev/null; then
    # Enable fzf key bindings
    if [ -f /usr/share/fzf/key-bindings.zsh ]; then
        source /usr/share/fzf/key-bindings.zsh
    elif [ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]; then
        source /usr/local/opt/fzf/shell/key-bindings.zsh
    elif [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
    fi

    # Enable fzf completion
    if [ -f /usr/share/fzf/completion.zsh ]; then
        source /usr/share/fzf/completion.zsh
    elif [ -f /usr/local/opt/fzf/shell/completion.zsh ]; then
        source /usr/local/opt/fzf/shell/completion.zsh
    fi

    # FZF default options
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always {}" --preview-window=right:60%:wrap'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# === Direnv ===
# Auto-load environment variables from .envrc files
if command -v direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi

# === ZSH Hooks ===
# Run functions at specific events

# Preexec: function to run before each command
preexec() {
    # Can be used for logging, notifications, etc.
}

# Precmd: function to run before each prompt
precmd() {
    # Update title with current directory
    print -Pn "\e]0;%~\a"
}

# === Local Overrides ===
# Source local machine-specific overrides if they exist
if [ -f ~/.config/zsh/.zshrc.local ]; then
    source ~/.config/zsh/.zshrc.local
fi

# === OS-Specific Overrides ===
# These will be layered on top by the installer
# source ~/.config/zsh/os/$(detect-os)/.zshrc
