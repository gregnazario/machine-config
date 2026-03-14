# Doom Emacs Configuration

Doom Emacs configuration with Dracula theme, all languages enabled, and Org Roam integration.

## Features

### Modules Enabled

**Languages**
- `:lang all` - All language modules enabled
- C/C++
- Python (with Pyright LSP)
- Rust
- TypeScript/JavaScript
- Go
- Java
- Lua
- YAML
- JSON
- Markdown
- Shell scripts (Fish, Bash)
- Scheme (Guile)
- GDScript
- LaTeX (with CDLaTeX)
- And many more...

**Other Modules**
- `:vc` - Version control (Magit)
- `:org` - Org Mode with extensions:
  - `+roam2` - Org Roam v2 for Zettelkasten notes
  - `+dragndrop` - Drag and drop images
  - `+present` - Presentation mode
  - `+gnuplot` - Gnuplot integration
  - `+hugo` - Hugo blogging

### UI Features
- **Theme**: Doom Dracula
- **Font**: JetBrains Mono (12pt)
- **Modeline**: Enhanced Doom modeline with LSP, Git info
- **Line Numbers**: Relative line numbers
- **Icons**: File icons in dired and neotree
- **Minimap**: Code minimap
- **Neotree**: File tree sidebar
- **Tabs**: Tab bar for buffer groups
- **Treemacs**: Project drawer

### Editor Features
- **Evil Mode** - Vim keybindings everywhere
- **LSP** - Eglot LSP client for all languages
- **Tree-sitter** - Enhanced syntax parsing
- **Snippets** - Auto-snippet templates
- **Company** - Code completion
- **Vertico** - Completion UI
- **Magit** - Git porcelain for Emacs
- **Org Roam** - Zettelkasten note-taking system
- **PDF** - PDF viewing and annotation
- **Eshell** - Elisp shell

## Installation

### Prerequisites

```bash
# Install Emacs 29+
# macOS
brew install emacs-plus@29

# Fedora
sudo dnf install emacs

# Ubuntu
sudo apt install emacs

# Arch
sudo pacman -S emacs

# Install Doom Emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

### Setup

```bash
# Copy Doom config
cp ~/.local/share/greg-config/editors/emacs/base/init.el ~/.config/doom/

# Sync Doom
~/.config/emacs/bin/doom sync

# Restart Emacs
```

## Org Mode Configuration

### Org Roam

**Directory**: `~/notes`

**Keybindings**:
- `SPC n r` - Org Roam commands
- `SPC n r f` - Find node
- `SPC n r i` - Insert node
- `SPC n r c` - Capture to node

**Capture Templates**:
- `t` - Todo (goes to `~/notes/todo.org`)
- `n` - Note (goes to `~/notes/notes.org`)
- `j` - Journal (goes to `~/notes/journal.org`)
- `p` - Project (goes to `~/notes/projects.org`)
- `r` - Reference (goes to `~/notes/reference.org`)

### Org Agenda

**Agenda Files**:
- `~/notes/todo.org`
- `~/notes/projects.org`
- `~/notes/journal.org`

**Keybindings**:
- `SPC o a` - Org Agenda

**Settings**:
- Week starts on Monday
- 2-week view
- Skip deadline/scheduled if done

### Org Babel

**Active Languages**:
- Python
- Shell
- Ruby
- JavaScript
- TypeScript
- Rust
- Go
- LaTeX
- SQL
- Calc
- C/C++

**Usage**:
```org
#+BEGIN_SRC python
print("Hello, World!")
#+END_SRC

# Press C-c C-c to execute
```

## LSP Configuration

**Enabled via**: `+lsp` and `+eglot`

**Languages**:
- Python - LSP mode
- JavaScript/TypeScript
- Rust
- Go
- Java
- Lua
- And all other languages

**LSP Keybindings**:
- `SPC c` - LSP execute code action
- `SPC r` - LSP rename
- `SPC f` - LSP format buffer
- `SPC R` - LSP find references

## Python Development

**Configured**:
- Python 3 interpreter
- `python3` for shell
- Pyright LSP via Eglot

**Keybindings**:
- `SPC m b` - Python REPL
- `SPC m c` - Run Python code

## Rust Development

**Configured**:
- Rust LSP via Eglot
- Auto-format via rustfmt

## Git Integration (Magit)

**Keybindings**:
- `SPC g g` - Magit status
- `SPC g b` - Magit blame
- `SPC g c` - Magit commit
- `SPC g f` - Magit fetch
- `SPC g p` - Magit push
- `SPC g P` - Magit pull

**Diffs**:
- Show diffs in fringe
- Refine hunks enabled

## File Management

**Dired**:
- Icons enabled
- Recursive delete: always
- Recursive copy: always
- Delete to trash: enabled

**Projectile**:
- Project search paths: `~/projects`, `~/work`, `~/code`
- Enable caching
- Ignored projects: `/tmp`, `~/.local`

## Customization

### Font

Change in `init.el`:

```elisp
(setq doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'regular))
```

### Theme

Change in `init.el`:

```elisp
(setq doom-theme 'doom-dracula)
;; Other options: 'doom-one, 'doom-nord, 'doom-tokyo-night
```

### Line Numbers

Change in `init.el`:

```elisp
(setq display-line-numbers-type t)  ; absolute
;; or
(setq display-line-numbers-type 'relative)  ; relative
```

## Org Mode Workflow

### Daily Journal

```bash
# Capture journal entry
SPC n r j
# Type entry
C-c C-c  # Save
```

### Project Notes

```bash
# Create new project note
SPC n r p
# Type project name and notes
C-c C-c  # Save

# Link to other notes
[[roam:node-id]]
```

### TODO Management

```bash
# Capture todo
SPC n r t
# Type todo

# View agenda
SPC o a
# Press 't' for todos
```

## Troubleshooting

### Doom won't start

```bash
# Sync Doom
~/.config/emacs/bin/doom sync

# Reinstall
~/.config/emacs/bin/doom install
```

### LSP not working

```bash
# Check LSP installed
SPC h d

# Install LSP manually
lsp-install-server
```

### Org Roam not working

```bash
# Check Org Roam database
ls ~/notes/org-roam.db

# Rebuild
SPC n r d
```

## Resources

- [Doom Emacs Documentation](https://docs.doomemacs.org/)
- [Org Mode Manual](https://orgmode.org/manual/)
- [Org Roam Manual](https://www.orgroam.com/)
- [Magit Manual](https://magit.vc/)
- [Dracula Theme](https://draculatheme.com/)

---

**Last Updated**: 2025-03-14
