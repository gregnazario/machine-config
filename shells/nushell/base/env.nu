# Nushell Configuration
# Base configuration for all operating systems
# https://www.nushell.sh/book/configuration.html

# === Environment Variables ===
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    $"($env.HOME)/.local/bin",
    $"($env.HOME)/bin",
    $"($env.HOME)/.cargo/bin"
] | uniq)

# Default editor
$env.EDITOR = if ("nvim" in (which nvim | get command | collect)) { "nvim" } else if ("vim" in (which vim | get command | collect)) { "vim" } else { "vi" }
$env.VISUAL = $env.EDITOR

# Pager
if ("bat" in (which bat | get command | collect)) {
    $env.PAGER = "bat"
} else {
    $env.PAGER = "less -FR"
}

# Language-specific
$env.PYTHONIOENCODING = "utf-8"
$env.CARGO_HOME = $"($env.HOME)/.cargo"
$env.GOPATH = $"($env.HOME)/go"

# Colors
$env.COLORTERM = "truecolor"
$env.TERM = "xterm-256color"

# === Starship Prompt ===
# Source starship config
# Create a custom prompt module
module starship_prompt {
    # Export the prompt function
    export def left_prompt [] {
        starship prompt
    }

    export def right_prompt [] {
        starship prompt --right
    }
}

# Use the module
use starship_prompt

# === Aliases ===
# Modern replacements
alias ls = ls --color=auto --group-directories-first
alias ll = ls -lh --color=auto
alias la = ls -lha --color=auto
alias lt = ls -lht --color=auto

# Safe core utils
alias rm = rm -i
alias cp = cp -i
alias mv = mv -i

# Modern replacements if available
if ("exa" in (which exa | get command | collect)) {
    alias ls = exa --group-directories-first --git
    alias ll = exa -lh --group-directories-first --git
    alias la = exa -lha --group-directories-first --git
    alias lt = exa --long --sort=modified --group-directories-first --git
}

if ("bat" in (which bat | get command | collect)) {
    alias cat = bat --paging=never
}

if ("btop" in (which btop | get command | collect)) {
    alias top = btop
} else if ("htop" in (which htop | get command | collect)) {
    alias top = htop
}

if ("dust" in (which dust | get command | collect)) {
    alias du = dust
}

# Git aliases
alias gst = git status
alias gco = git checkout
alias gbr = git branch
alias glog = git log --oneline --graph --decorate
alias gadd = git add
alias gcom = git commit
alias gpush = git push
alias gpull = git pull
alias gdiff = git diff
alias gmerge = git merge
alias grebase = git rebase
alias greset = git reset
alias gundo = git reset --soft HEAD~1
alias glast = git log -1 --stat

# Directory navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..

# === Custom Commands ===

# Quick edit configs
def "edit zshrc" [] { nvim ~/.config/zsh/.zshrc }
def "edit starship" [] { nvim ~/.config/starship.toml }
def "edit nu" [] { nvim $"($env.HOME)/.config/nushell/env.nu" }

# Enhanced cd with directory hash support
def-env cd [...rest] {
    let path = ($rest | str join " ")

    # Directory hashes
    const dir_hashes = {
        "projects": $"($env.HOME)/projects",
        "work": $"($env.HOME)/work",
        "dotfiles": $"($env.HOME)/.local/share/greg-config"
    }

    if ($path in $dir_hashes) {
        builtin cd $dir_hashes.$path
    } else if ($path != "") {
        builtin cd $path
    } else {
        builtin cd
    }
}

# === FZF Integration ===
if ("fzf" in (which fzf | get command | collect)) {
    $env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --preview 'bat --color=always {}' --preview-window=right:60%:wrap"
    $env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude node_modules"
    $env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
}

# === Error Formatting ===
# Colorful error messages
$env.NU_ERROR_FORMAT = "%{msg} %{err}"

# === External Integrations ===

# Zoxide (better cd)
if ("zoxide" in (which zoxide | get command | collect)) {
    zoxide init nushell | save -f $nu.zodir/zoxide.nu
    source $nu.zodir/zoxide.nu
}

# === History ===
$env.HISTFILE = $"($env.HOME)/.cache/nushell/history.txt"
$env.HISTSIZE = 10000

# === Prompt Theme ===
# Additional prompt customization
def create_left_prompt [] {
    starship_prompt left_prompt
}

def create_right_prompt [] {
    starship_prompt right_prompt
}

# Use the custom prompts
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }

# === Local Overrides ===
if ("nu" in (ls ~/.config/nushell/env.local.nu | get name | collect)) {
    source ~/.config/nushell/env.local.nu
}
