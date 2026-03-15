# FZF (Fuzzy Finder) Configuration
# Base configuration for all operating systems
# Source this file in your shell config

# === FZF Default Options ===
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview "bat --color=always {}"
  --preview-window=right:60%:wrap
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f38ba8
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=separator:#45475a
'

# === FZF Default Command ===
# Use fd for file searching (faster and respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'

# === CTRL-T - Paste the selected file path(s) into the command line ===
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='
  --preview "bat --color=always --line-range :500 {}"
  --multi
'

# === CTRL-R - Paste the selected command from history into the command line ===
export FZF_CTRL_R_OPTS='
  --sort
  --preview "echo {}"
  --preview-window down:3:hidden:wrap
  --bind "ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"
  --bind "ctrl-e:execute(echo {+} | less -F)"
  --header "Press CTRL-Y to copy, CTRL-E to view"
'

# === ALT-C - cd into the selected directory ===
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
export FZF_ALT_C_OPTS='
  --preview "tree -C {} | head -100"
  --header "Press ENTER to change directory"
'

# === CTRL-G - FZF for Git objects ===
# Show git files (fuzzy search files in git)
_fzf_git_files() {
	git -c color.status=always status --short |
		fzf --height 40% --border --multi --ansi \
			--nth 2..,.. \
			--preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
		cut -c4- | sed 's/.* -> //'
}

# Show git branches (fuzzy search branches)
_fzf_git_branch() {
	git branch -a --color=always | grep -v '/HEAD\s' | sort |
		fzf --height 40% --border --ansi --tac --preview-window right:70% \
			--preview 'git log --oneline --graph --date=short --color=always "$(sed s/^..// <<< {} | sed "s/ .*//")"' |
		sed 's/^..//' | sed 's/ .*//' | head -n1
}

# Show git tags (fuzzy search tags)
_fzf_git_tag() {
	git tag --sort -version:refname |
		fzf --height 40% --border --preview 'git show --color=always {} | head -200'
}

# Show git commits (fuzzy search commits)
_fzf_git_commit() {
	git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s" |
		fzf --height 40% --border --ansi --no-sort --reverse --multi \
			--preview 'git show --color=always {+1} | head -200' |
		awk '{print $5}'
}

# Show git history (fuzzy search commit history)
_fzf_git_history() {
	_fzf_git_commit |
		xargs -I{} git diff --color=always {}^ {}
}

# === FZF for File Content Search (using ripgrep) ===
_fzf_rg() {
	rg --color=always --line-number --no-heading --smart-case "${@:-}" |
		fzf --height 40% --border --ansi \
			--color "hl:-1:underline,hl+:-1:underline:reverse" \
			--delimiter : \
			--preview 'bat --color=always {1} --highlight-line {2}' \
			--preview-window 'right:60%:wrap:+{2}+3/3' \
			--bind 'enter:become(vim {1} +{2})'
}

# === FZF for Kill Process ===
_fzf_kill() {
	ps -ef | sed 1d | fzf -m --height 40% --border --preview 'echo {}' --preview-window down:3:wrap |
		awk '{print $2}' |
		xargs kill -${1:-9}
}

# === FZF for CD with Zoxide/Autojump support ===
# If you use zoxide or autojump, this provides a fuzzy interface

# === Shell Integration ===

# Use fd instead of find for ALT-C
if command -v fd >/dev/null; then
	export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
fi

# Advanced file opening with FZF
# Usage: fe [fzf query]
fe() {
	local files
	IFS=$'\n' files=($(fzf-tm --query="$1" --multi --select-1 --exit-0))
	[[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# FZF + vim
# Usage: vf [fzf query]
vf() {
	local file
	file=$(fzf --query="$1" --select-1 --exit-0)
	[ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# FZF + cd (including hidden directories)
# Usage: fd [fzf query]
fd() {
	local dir
	dir=$(find ${1:-.} -type d -print 2>/dev/null | fzf +m)
	cd "$dir"
}

# FZF + cd with recent directories
# Uses z if available, otherwise falls back to pushd
if command -v z >/dev/null; then
	# Use zoxide/z
	_fzf_z() {
		[ $# -gt 0 ] && z "$*"
		cd "$(z -l 2>/dev/null | sed 's/^[0-9,.]* *//' | fzf --height 40% --border --nth 2.. --reverse --inline-info +s --tac)"
	}
else
	_fzf_z() {
		cd "$(dirs -lp | sed 's/\t[0-9]\t//' | fzf --height 40% --border --nth 2.. --reverse --inline-info +s --tac)"
	}
fi

# === FZF for Tmux ===
# Switch tmux sessions with FZF
_ftsu() {
	local session
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null |
		fzf --height 40% --border --exit-0) &&
		tmux switch-client -t "$session"
}

# === FZF for Docker ===
# Select running docker containers
_fzf_docker_ps() {
	docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" |
		fzf --height 40% --border --header-lines=1 --delimiter="\t" \
			--preview 'docker logs --tail 50 {1}' |
		awk '{print $1}'
}

# Select docker images
_fzf_docker_images() {
	docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" |
		fzf --height 40% --border --header-lines=1 --delimiter="\t" |
		awk '{print $1}'
}

# === Bindings (for bash) ===
if [[ $- == *i* ]]; then
	# CTRL-T - Paste the selected file path into the command line
	bind '"\C-t": "fzf-file-widget"'
	bind '"\C-r": "fzf-history-widget"'
	bind '"\C-g": "_fzf_git_files"'
fi

# === Environment Variables ===

# Disable tmux pane title updates when running fzf (performance)
export FZF_TMUX=1

# Default tmux height (for use inside tmux)
export FZF_TMUX_HEIGHT=40%

# === Key Bindings ===

# CTRL-G - Git files
bind '"\C-g": "_fzf_git_files"'

# CTRL-O - FZF for opening files (custom)
# bind '"\C-o": "fe\n"'

# === Custom FZF Functions ===

# Search and install with brew (macOS)
brew_install() {
	local formula
	formula=$(brew search "$@" | fzf --height 40% --border | sed 's/==.*//')
	brew install "$formula"
}

# Search and install with apt (Debian/Ubuntu)
apt_install() {
	local package
	package=$(apt-cache search "$@" | fzf --height 40% --border | awk '{print $1}')
	sudo apt install -y "$package"
}

# Search and install with dnf (Fedora)
dnf_install() {
	local package
	package=$(dnf search "$@" | fzf --height 40% --border | awk '{print $1}')
	sudo dnf install -y "$package"
}

# Search and install with pacman (Arch)
pacman_install() {
	local package
	package=$(pacman -Ss "$@" | fzf --height 40% --border | awk '{print $1}')
	sudo pacman -S "$package"
}

# === Integration with other tools ===

# Use bat for syntax-highlighted preview (if available)
if command -v bat >/dev/null; then
	export FZF_PREVIEW_COMMAND='bat --color=always --line-range :500 {}'
fi

# Use tree for directory preview (if available)
if command -v tree >/dev/null; then
	export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"
fi

# === Performance Tweaks ===

# Use faster commands for FZF
if command -v fd >/dev/null; then
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi

if command -v rg >/dev/null; then
	# Use ripgrep for content search
	alias rgf='_fzf_rg'
fi

# === Notes ===
# This file should be sourced in your shell config:
# - For bash: source ~/.config/fzf/fzf.bash
# - For zsh: source ~/.config/fzf/fzf.zsh
# - For fish: ~/.config/fzf/fzf.fish (functions, not vars)

# FZF key bindings:
# - CTRL-T: Paste selected files from filesystem
# - CTRL-R: Paste selected command from history
# - ALT-C: cd into selected directory
# - CTRL-G: Git file selector (custom)

# For more information, see: https://github.com/junegunn/fzf
