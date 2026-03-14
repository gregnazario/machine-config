# GitHub CLI (gh) Configuration

GitHub CLI with extensions (gh-dash, gh-eco, gh-i, gh-poi) and SSH key authentication.

## Features

### Core Features
- **SSH Authentication** - Use SSH keys for git operations
- **Aliases** - Convenient aliases for common commands
- **Extensions** - Enhanced functionality with extensions

### Extensions
- **gh-dash** - Interactive dashboard for GitHub
- **gh-eco** - Contributions graph
- **gh-i** - Interactive issue management
- **gh-poi** - PR management

### Core Commands
- `gh pr` - Pull request operations
- `gh issue` - Issue operations
- `gh repo` - Repository operations
- `gh gist` - Gist operations
- `gh auth` - Authentication
- `gh run` - GitHub Actions

## Installation

### Prerequisites

```bash
# Install GitHub CLI
# macOS
brew install gh

# Fedora
sudo dnf install gh

# Ubuntu
sudo apt install gh

# Arch
sudo pacman -S gh

# Install extensions
gh extension install dlvhdr/gh-dash
gh extension install hanked/gh-eco
gh extension install dlvhdr/gh-i
gh extension install seachicken/gh-poi
```

### Setup

```bash
# Copy config to gh directory
mkdir -p ~/.config/gh
cp ~/.local/share/greg-config/version-control/gh/base/config.yml ~/.config/gh/

# Authenticate with GitHub
gh auth login

# Or authenticate with SSH
gh auth login --with-ssh

# Set Git protocol to SSH
gh config set git_protocol ssh

# Verify
gh auth status
```

## Usage

### Authentication

```bash
# Login to GitHub
gh auth login

# Login with SSH
gh auth login --with-ssh

# Login with GitHub Enterprise
gh auth login --hostname enterprise.github.com

# Check auth status
gh auth status

# Logout
gh auth logout

# Switch accounts
gh auth switch
```

### Pull Requests

```bash
# List PRs
gh pr list

# View PR
gh pr view 123

# Create PR
gh pr create --title "Add new feature" --body "Description"

# Checkout PR
gh pr checkout 123

# Merge PR
gh pr merge 123

# Close PR
gh pr close 123

# Comment on PR
gh pr comment 123 --body "Great work!"

# Diff PR
gh pr diff 123

# Checks
gh pr checks 123

# View PR status
gh pr view 123 --json status

# List PR reviews
gh pr view 123 --json reviews

# Web view
gh pr view 123 --web

# List open PRs
gh pr list --state open

# List closed PRs
gh pr list --state closed

# List merged PRs
gh pr list --state merged

# Search PRs
gh pr list --search "label:bug"

# Filter by author
gh pr list --author greg
```

### Issues

```bash
# List issues
gh issue list

# View issue
gh issue view 123

# Create issue
gh issue create --title "Bug report" --body "Description"

# Close issue
gh issue close 123

# Reopen issue
gh issue reopen 123

# Comment on issue
gh issue comment 123 --body "I'm working on this!"

# Assign issue
gh issue edit 123 --add-assignee @username

# Add label
gh issue edit 123 --add-label "bug"

# Add milestone
gh issue edit 123 --milestone "v1.0"

# List issues in repo
gh issue list --limit 100

# Search issues
gh issue list --search "is:open label:bug"
```

### Repositories

```bash
# List repos
gh repo list

# View repo
gh repo view

# Create repo
gh repo create myrepo --public

# Create private repo
gh repo create myrepo --private

# Fork repo
gh repo fork owner/repo

# Clone repo
gh repo clone owner/repo

# Delete repo
gh repo delete myrepo

# View repo settings
gh repo view --json settings
```

### Gists

```bash
# List gists
gh gist list

# Create gist
gh gist create file.txt --desc "My gist"

# View gist
gh gist view abc123

# Edit gist
gh gist edit abc123 --desc "Updated description"

# Delete gist
gh gist delete abc123

# List private gists
gh gist list --public false
```

### Workflow Runs

```bash
# List workflow runs
gh run list

# View run
gh run view 123

# View run logs
gh run view 123 --log

# Rerun failed tests
gh run rerun 123

# Cancel run
gh run cancel 123

# Watch run
gh run watch 123

# List runs for workflow
gh run list --workflow test.yml
```

### Extensions

```bash
# List installed extensions
gh extension list

# Install extension
gh extension install owner/repo

# Remove extension
gh extension remove owner/repo

# Upgrade all extensions
gh extension upgrade --all

# gh-dash: Dashboard
gh dash

# gh-eco: Contributions
gh eco

# gh-i: Interactive issues
gh i

# gh-poi: PR management
gh poi
```

## gh-dash

```bash
# Open gh-dash
gh dash

# Navigation
- Tab: Switch sections
- Enter: Open in browser
- o: Open in gh pr view
- v: View diff
- c: Add comment
- r: Refresh
- ?: Help
- q: Quit
```

## gh-eco

```bash
# Show contributions
gh eco

# View contributions
gh eco view

# Sync contributions
gh eco sync
```

## gh-i

```bash
# Interactive issue manager
gh i

# List issues
gh i list

# View issue
gh i view

# Create issue
gh i create

# Search issues
gh i search
```

## gh-poi

```bash
# PR management
gh poi

# List PRs
gh poi list

# View PR
gh poi view

# Checkout PR
gh poi checkout

# View diff
gh poi diff
```

## Configuration

### Git Protocol

```bash
# Set to SSH (recommended)
gh config set git_protocol ssh

# Set to HTTPS
gh config set git_protocol https
```

### Editor

```bash
# Set editor
gh config set editor nvim

# Set editor with options
gh config set editor "nvim +StartInsert"
```

### Browser

```bash
# Set browser
gh config set browser firefox

# Set browser on macOS
gh config set browser open
```

### Aliases

```bash
# Create alias
gh alias set co 'pr checkout'

# List aliases
gh alias list

# Delete alias
gh alias delete co

# Extend alias
gh alias extend --shell
```

## Aliases

### PR Aliases

```bash
# List PRs
gh prs

# Create PR
gh prc

# Checkout PR
gh co

# View PR
gh vi

# View in browser
gh vw

# Merge PR
gh merge

# List PR reviews
gh pr review

# List PR comments
gh pr comment
```

### Issue Aliases

```bash
# List issues
gh is

# Create issue
gh ic

# View issue
gh iv

# Close issue
gh iclose

# Reopen issue
gh ireopen

# Comment on issue
gh icomment

# Assign issue
gh iassign

# Add label
gh ilabel
```

### Repo Aliases

```bash
# List repos
gh repos

# Create repo
gh new

# Fork repo
gh fork

# Clone repo
gh clone

# Delete repo
gh rm
```

## Tips

### Quick PR from branch

```bash
# Create PR from current branch to main
gh pr create --base main --head feature-branch

# With title and description
gh pr create \
  --title "Add new feature" \
  --body "Description of changes" \
  --base main
```

### Bulk PR operations

```bash
# List all PRs
gh pr list --limit 100

# Filter PRs by label
gh pr list --search "label:bug"

# Filter PRs by state
gh pr list --state merged

# Filter PRs by author
gh pr list --author greg
```

### Issue Templates

```bash
# Create issue from template
gh issue create --template bug_report.md

# Use template
gh issue create --template feature_request.md
```

### Workflow

```bash
# CI/CD workflow
gh run list --workflow ci.yml

# Watch workflow
gh run watch

# Re-run workflow
gh run rerun 123

# Cancel workflow
gh run cancel 123
```

## Troubleshooting

### Authentication issues

```bash
# Logout
gh auth logout

# Re-authenticate
gh auth login --with-ssh

# Check status
gh auth status
```

### Extension issues

```bash
# Remove extension
gh extension remove owner/repo

# Re-install
gh extension install owner/repo

# Upgrade
gh extension upgrade --all
```

### Config not working

```bash
# Verify config location
gh config list

# Check config syntax
cat ~/.config/gh/config.yml

# Reset config
gh config set git_protocol https
```

## Resources

- [gh Documentation](https://cli.github.com/manual/)
- [gh Extensions](https://github.com/cli/gh-extensions)
- [gh-dash](https://github.com/dlvhdr/gh-dash)
- [gh-eco](https://github.com/hanked/gh-eco)
- [gh-i](https://github.com/dlvhdr/gh-i)
- [gh-poi](https://github.com/seachicken/gh-poi)

---

**Last Updated**: 2025-03-14
