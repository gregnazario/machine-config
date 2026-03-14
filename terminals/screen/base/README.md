# GNU Screen Terminal Multiplexer

GNU Screen is a terminal multiplexer that allows multiple terminal sessions within a single window.

## Features

### Core Features
- **Persistent Sessions** - Sessions survive disconnection
- **Split Windows** - Split screen horizontally and vertically
- **Multiple Windows** - Multiple terminal windows in one session
- **Scrollback Buffer** - Large scrollback history (10,000 lines)
- **Copy Mode** - Vim-like copy and paste
- **Status Bar** - Informational status bar with window list
- **UTF-8 Support** - Full UTF-8 encoding support
- **256 Colors** - True color support

### Keybindings
- **Ctrl+a** - Command prefix (like tmux)
- **Ctrl+a c** - Create new window
- **Ctrl+a n** - Next window
- **Ctrl+a p** - Previous window
- **Ctrl+a w** - Window list
- **Ctrl+a "Space"** - Window list
- **Ctrl+a 0-9** - Select window by number
- **Ctrl+a d** - Detach session
- **Ctrl+a S** - Split horizontally
- **Ctrl+a V** - Split vertically
- **Ctrl+a Tab** - Navigate between splits
- **Ctrl+a K** - Kill window
- **Ctrl+a A** - Rename window
- **Ctrl+a [** - Enter copy mode
- **Ctrl+a ]** - Paste buffer

## Installation

### Prerequisites

```bash
# Install Screen
# macOS
brew install screen

# Fedora
sudo dnf install screen

# Ubuntu
sudo apt install screen

# Arch
sudo pacman -S screen

# Gentoo
sudo emerge app-misc/screen

# Void
sudo xbps-install screen

# Alpine
sudo apk add screen

# FreeBSD
sudo pkg install screen
```

### Setup

```bash
# Copy config to home directory
cp ~/.local/share/greg-config/terminals/screen/base/.screenrc ~/

# Or create symlink
ln -s ~/.local/share/greg-config/terminals/screen/base/.screenrc ~/.screenrc

# Start Screen
screen

# Or start with session name
screen -S mysession
```

## Usage

### Session Management

```bash
# Start new screen session
screen

# Start named session
screen -S mysession

# List sessions
screen -ls

# Attach to session
screen -r

# Attach to named session
screen -r mysession

# Attach to session if unique, otherwise list
screen -x

# Detach from session
# Press Ctrl+a d

# Kill session
screen -XS mysession quit

# Kill all sessions
screen -ls | grep pts | awk '{print $1}' | xargs -I {} screen -X -S {} quit
```

### Window Management

```bash
# Create new window
# Ctrl+a c

# Switch to window by number
# Ctrl+a 0-9

# Next window
# Ctrl+a n or Ctrl+a Space

# Previous window
# Ctrl+a p

# List windows
# Ctrl+a w

# Rename window
# Ctrl+a A

# Kill window
# Ctrl+a K
```

### Split Screen

```bash
# Split horizontally
# Ctrl+a S

# Split vertically
# Ctrl+a V

# Navigate between splits
# Ctrl+a Tab

# Close all splits except current
# Ctrl+a Q

# Close current split
# Ctrl+a X
```

### Copy Mode

```bash
# Enter copy mode
# Ctrl+a [

# Navigation (vim-style):
# h/j/k/l - Move left/down/up/right
# w/b - Move by word
# 0/$ - Start/end of line
# gg/G - Start/end of buffer
# / - Search forward
# ? - Search backward

# Mark start of copy:
# Space

# Mark end of copy (copy to buffer):
# Space

# Paste buffer:
# Ctrl+a ]
```

### Scrollback

```bash
# Enter copy mode to scroll back
# Ctrl+a [

# Use j/k or arrow keys to scroll

# Search in scrollback:
# /pattern

# Exit copy mode
# Esc
```

### Logging

```bash
# Screen automatically logs to /tmp/screen-%n.%Y%m%d-%H%M%S.log
# %n = window number
# %Y = year, %m = month, %d = day
# %H = hour, %M = minute, %S = second

# View logs
ls -la /tmp/screen-*

# Disable logging
# Add to .screenrc: deflog off
```

## Configuration

### Command Key

The default command key is `Ctrl+a`. To change it:

```bash
# In .screenrc, change:
escape ^aa    # First character is Ctrl, second is 'a'
# To use Ctrl+j:
escape ^jj
```

### Scrollback

```bash
# Change scrollback buffer size
defscrollback 10000

# Or per window:
screen -t "Window" 1 defscrollback 20000
```

### Status Bar

```bash
# Customize hardstatus line
hardstatus string '%{= kG}[%= %{= kw}%?%F%?%?%h%:%t %?%{= kG}%?%{= kw}%?%{= kG}][%{= kB}%Y-%m-%d %{= kW}%c:%s %{= kG}]'

# Format options:
# %n - Window number
# %t - Window title
# %h - Window title (shortened)
# %F - Window flags
# %Y - Year
# %m - Month
# %d - Day
# %c - Time (HH:MM)
# %s - Seconds
```

### Window Numbering

```bash
# Start windows from 1 instead of 0
bind 0 select 10
bind c screen 1
bind ^c screen 1
```

### Colors

Screen supports 256 colors. The configuration includes Dracula-like colors:
- **Background**: Dark gray
- **Foreground**: White/light gray
- **Highlight**: Purple/pink
- **Status bar**: Green/cyan

## Advanced Usage

### Shared Sessions

```bash
# Start session in multiuser mode
screen -S shared -dm

# Allow multiuser
screen -S shared -X multiuser on

# Allow other user
screen -S shared -X acladd username

# Other user attaches
screen -x username/shared
```

### Remote Pair Programming

```bash
# On host machine:
screen -S pair

# Allow multiuser:
screen -S pair -X multiuser on
screen -S pair -X acladd partner

# Partner connects:
ssh host
screen -x yourname/pair
```

### Screen as SSH Keepalive

```bash
# Start screen session on remote server
ssh server
screen -S work

# Detach: Ctrl+a d

# Reattach later:
ssh server
screen -r work

# Session survives network disconnection
```

### Scripting

```bash
# Start screen with command in window
screen -dmS mysession bash -c "long_command; exec bash"

# Send commands to screen window
screen -S mysession -p 0 -X stuff "echo 'hello'\n"

# Create named window
screen -S mysession -X screen -t "logs" 1 tail -f /var/log/syslog
```

## Troubleshooting

### Cannot attach to session

```bash
# Force attach (detach other users)
screen -x -r mysession

# Or kill the session
screen -X -S mysession quit
```

### Screen not responding

```bash
# Kill screen session
screen -X -S mysession quit

# Or kill all screen processes
pkill screen
```

### Scrollback not working

```bash
# Make sure you're in copy mode: Ctrl+a [

# Check defscrollback is set:
grep defscrollback ~/.screenrc
```

### Colors not displaying correctly

```bash
# Ensure 256 color support:
export TERM=xterm-256color

# Or in .screenrc:
termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'
```

### Screen exits when closing last window

```bash
# This is default behavior. To keep screen alive:
# Add to .screenrc:
zombie '^['
```

## Comparison with tmux and Zellij

**Screen:**
- Oldest, most portable
- Available everywhere by default
- Simpler configuration
- Less features than tmux/zellij

**tmux:**
- More modern than screen
- Better split window support
- More customizable
- Client-server model

**Zellij:**
- Most modern
- Written in Rust
- Best UI/UX
- Plugin system
- Scrollback by default

All three are excellent! Choose based on availability and preference.

## Resources

- [GNU Screen Manual](https://www.gnu.org/software/screen/manual/)
- [Screen Quick Reference](https://www.delorie.com/gnu/docs/screen/screen_13.html)
- [Screen on Arch Wiki](https://wiki.archlinux.org/title/GNU_Screen)

---

**Last Updated**: 2025-03-14
