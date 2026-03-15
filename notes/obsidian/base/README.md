# Obsidian - Note-Taking and Knowledge Base

Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files.

## Features

### Core Features
- **Markdown** - Plain text Markdown files
- **Linking** - Wiki-style linking [[like this]]
- **Graph View** - Visual relationship graph
- **Backlinks** - See what links to current note
- **Tags** - Organize with #tags
- **Plugins** - Extensive plugin ecosystem
- **Themes** - Custom themes
- **Cross-Platform** - Desktop and mobile apps
- **Local Files** - Your data stays with you
- **Version Control** - Works with git
- **Search** - Fast full-text search
- **Templates** - Note templates
- **Canvas** - Visual organization
- **Properties** - YAML frontmatter metadata

### Advantages
- Local-first (no cloud lock-in)
- Plain Markdown (portable)
- Extensible with plugins
- Active community
- Free for personal use
- Works with version control
- Multi-device sync options

## Installation

### Prerequisites

```bash
# Install Obsidian
# macOS
brew install --cask obsidian

# Fedora
# Download .rpm from https://obsidian.md/download
sudo dnf install ./obsidian-*.rpm

# Ubuntu
# Download .deb from https://obsidian.md/download
sudo dpkg -i obsidian-*.deb

# Arch
sudo pacman -S obsidian

# Gentoo
# Ebuild available or manual install

# Void
sudo xbps-install obsidian

# Alpine
# Download AppImage from website

# FreeBSD
# Download from website (not in packages)

# Windows (11)
# Download .exe from https://obsidian.md
winget install Obsidian.Obsidian
```

### Setup

```bash
# Create vault directory
mkdir -p ~/notes/obsidian

# Open Obsidian
# Select "Open folder as vault"
# Choose ~/notes/obsidian

# Or create new vault
# Open Obsidian -> Create new vault
```

## Configuration

### Obsidian Settings

Obsidian stores settings in `.obsidian/` folder in your vault:

```
.obsidian/
├── app.json              # App settings
├── appearance.json       # Theme and appearance
├── community-plugins.json # Installed plugins
├── hotkeys.json          # Keyboard shortcuts
├── plugins/              # Plugin data
├── themes/               # Installed themes
├── templates/            # Template files
├── workspace.json        # Workspace layout
└── workspace-mobile.json # Mobile workspace
```

### Key Configuration Files

#### .obsidian/app.json

```json
{
  "legacyEditor": false,
  "livePreview": true,
  "showLineNumber": true,
  "foldHeading": true,
  "foldIndent": true,
  "showFrontmatter": true,
  "alwaysUpdateLinks": true,
  "useMarkdownLinks": false,
  "newFileLocation": "current",
  "attachmentFolderPath": "attachments",
  "promptDelete": false
}
```

#### .obsidian/appearance.json

```json
{
  "baseFontSize": 16,
  "theme": "obsidian",
  "accentColor": "#5e81ac",
  "showViewHeader": true
}
```

#### .obsidian/hotkeys.json

```json
{
  "command-palette:open": [
    {
      "modifiers": [
        "Mod",
        "Shift"
      ],
      "key": "P"
    }
  ]
}
```

## Usage

### Basic Markdown

```markdown
# Heading 1

## Heading 2

**Bold** and *italic* and `code`

- List item
- Another item

1. Numbered item
2. Another

> Blockquote

```
Code block
```

[[Link to other note]]

#tag
```

### Wiki Links

```markdown
# Link to note
[[Note Name]]

# Link with alias
[[Note Name|Display Text]]

# Link to heading
[[Note Name#Heading]]

# Link to block (paragraph)
[[Note Name^blockid]]

# Embed note
![[Note Name]]
```

### Tags

```markdown
# Single tag
#todo

# Nested tag
#work/project

# Multi-word tag
#"multi word tag"

# Tag in metadata
---
tags: [todo, work/project, important]
---
```

### Frontmatter

```yaml
---
title: My Note
created: 2025-03-14
tags: [todo, work]
status: in-progress
---

# Content here
```

### Embeds

```markdown
# Embed image
![[image.png]]

# Embed PDF
![[document.pdf]]

# Embed note
![[Other Note]]

# Embed section
![[Other Note#Heading]]

# Embed with transclusion
![[Other Note#^blockid]]
```

## Practical Examples

### Daily Notes

```markdown
---
date: 2025-03-14
tags: [daily-note]
---

## Tasks

- [ ] Task 1
- [x] Completed task

## Notes

Today I worked on...

## Tomorrow

- Remember to...
```

### Zettelkasten Notes

```markdown
---
tags: [permanent-note]
---

# Understanding REST APIs

REST APIs are stateless...

## Related

- [[HTTP Methods]]
- [[API Authentication]]
- [[REST vs GraphQL]]
```

### Project Notes

```markdown
---
project: Website Redesign
status: In Progress
tags: [project, work]
due: 2025-04-01
---

# Website Redesign Project

## Tasks

- [ ] Design mockups
- [ ] Get approval
- [ ] Implement frontend
- [ ] Deploy

## Meeting Notes

### 2025-03-14

Discussed timeline and budget...

## Resources

- [[Design Requirements]]
- [[Technical Specs]]
```

### Book Notes

```markdown
---
title: "The Pragmatic Programmer"
author: Andrew Hunt, David Thomas
status: Read
tags: [book, programming]
rating: 5/5
---

# The Pragmatic Programmer

## Key Takeaways

- Tip 1: Care about your craft
- Tip 2: Think about your work
- Tip 3: Provide options, don't make lame excuses

## Notes

Chapter 1 discusses...
```

### Meeting Notes

```markdown
---
type: meeting
attendees: [Alice, Bob, Charlie]
date: 2025-03-14
tags: [meeting, work]
---

# Team Meeting - 2025-03-14

## Attendees
- Alice
- Bob
- Charlie

## Agenda

1. Sprint review
2. Planning next sprint
3. Blockers

## Notes

### Sprint Review

- Completed 5 stories
- 2 bugs found in testing

### Planning

Next sprint goals...

## Action Items

- [ ] Alice: Review PR #123
- [ ] Bob: Update documentation
- [ ] Charlie: Fix bug #456
```

## Plugins

### Essential Plugins

```bash
# Install community plugins
Settings -> Community Plugins -> Browse -> Search

# Recommended:
- Dataview - Query your notes
- Templater - Advanced templates
- Calendar - Calendar view for daily notes
- Kanban - Kanban boards
- Tasks - Task management
- Excalidraw - Hand-drawn diagrams
- Advanced Tables - Better tables
- Obsidian Git - Version control
```

### Dataview

```markdown
---
tags: [dataview]
---

# Project Overview

```dataview
TABLE file.ctime as "Created", status
FROM "projects"
WHERE status = "In Progress"
SORT file.ctime DESC
```

## Tasks by Tag

```dataview
TASK
FROM #todo
WHERE !completed
GROUP BY tags
```
```

### Templates

```markdown
# Template file (in templates folder)

---
date: {{date}}
tags: [daily-note]
---

# Daily Note - {{date}}

## Tasks

- [ ]

## Notes

## Tomorrow

---
```

```markdown
# Use template
# In daily note:
Ctrl/Cmd + T -> Select template

# Variables:
{{date}} - Current date
{{time}} - Current time
{{title}} - Note title
```

## Tips

### Productivity

```markdown
# Use templates for consistency
# Create templates for:
- Daily notes
- Meeting notes
- Book notes
- Project notes

# Use tags for organization
# Hierarchical tags:
#project/name
#work/client
```

### Organization

```markdown
# Folder structure:
- Inbox/         # Quick capture
- Daily Notes/   # Daily notes by date
- Projects/      # Project notes
- Areas/         # Ongoing responsibilities
- Resources/     # Reference material
- Archives/      # Old completed items

# Use tags for cross-references
# Multiple tags on one note
```

### Linking

```markdown
# Create links liberally
# Use [[wiki links]] not [markdown links]()
# Let backlinks guide discovery

# Use graph view
# Visualize connections
# Find orphaned notes
```

### Search

```markdown
# Search operators:
tag:#todo               # Tag search
file:meeting            # File name search
path:Projects/          # Path search
content:API             # Content search
-line:block             # Exclude

# Combine searches:
tag:#work AND file:meeting
path:Daily/ OR tag:#daily
```

## Aliases

Add to shell config:

```bash
# Obsidian aliases
alias obs='open -a Obsidian'                     # macOS
alias obsi='open -a Obsidian ~/notes/obsidian'   # macOS

# Linux:
alias obs='obsidian'
alias obsi='obsidian ~/notes/obsidian'
```

## Troubleshooting

### "Plugins not working"

```bash
# Enable community plugins
Settings -> Community plugins -> Turn on

# Check plugin is installed
Settings -> Community plugins -> Browse -> Search

# Check for updates
Settings -> Community plugins -> Check for updates
```

### "Graph view empty"

```markdown
# Create some notes with links
# Use [[wiki links]]
# Add tags

# Rebuild graph
Settings -> Files & Links -> Rebuild graph
```

### "Sync issues"

```bash
# Use Obsidian Sync (paid)
# Or use third-party:
- Git (with Obsidian Git plugin)
- Syncthing
- Dropbox
- Google Drive
```

## Git Integration

```bash
# Initialize git in vault
cd ~/notes/obsidian
git init

# Create .gitignore
echo ".obsidian/workspace" > .gitignore
echo ".obsidian/workspace-mobile" >> .gitignore
echo ".trash/" >> .gitignore

# Commit changes
git add .
git commit -m "Initial commit"

# Or use Obsidian Git plugin
# Settings -> Community Plugins -> Browse -> Obsidian Git
```

## Comparison

**Obsidian:**
- Local-first
- Plain Markdown
- Extensible
- Active community
- Cross-platform
- Free for personal use

**Notion:**
- Cloud-based
- Proprietary format
- Databases
- Collaboration
- Freemium

**Roam Research:**
- Cloud-based
- Block-based
- Outliner-focused
- Expensive
- Web app

**Logseq:**
- Local-first
- Block-based
- Outliner
- Open source
- Graph-focused

## Resources

- [Obsidian Website](https://obsidian.md/)
- [Obsidian Help](https://help.obsidian.md/)
- [Obsidian Publish](https://publish.obsidian.md/)
- [Obsidian Sync](https://obsidian.md/sync)
- [Obsidian Plugins](https://obsidian.md/plugins)

---

**Last Updated**: 2025-03-14
