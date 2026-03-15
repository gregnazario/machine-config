# HTTPie - User-Friendly HTTP Client

HTTPie (aitch-tee-tee-pie) is a command-line HTTP client with an intuitive UI, JSON support, syntax highlighting, and more.

## Features

### Core Features
- **Intuitive Syntax** - Simple, natural syntax
- **JSON Support** - Built-in JSON parsing and formatting
- **Syntax Highlighting** - Colorized output
- **WebSocket Support** - Real-time communication
- **Form/File Upload** - Multipart file uploads
- **Authentication** - Multiple auth methods
- **Sessions** - Persistent cookies and headers
- **Proxies** - HTTP/HTTPS proxy support
- **Redirects** - Follow redirects automatically
- **Offline Mode** - Build requests without sending

### Advantages Over curl
- Readable syntax
- JSON parsing
- Syntax highlighting
- Form support
- Session support
- Better error messages
- More intuitive

## Installation

### Prerequisites

```bash
# Install HTTPie
# macOS
brew install httpie

# Fedora
sudo dnf install httpie

# Ubuntu
sudo apt install httpie

# Arch
sudo pacman -S httpie

# Gentoo
sudo emerge net-misc/httpie

# Void
sudo xbps-install httpie

# Alpine
sudo apk add httpie

# FreeBSD
sudo pkg install httpie

# Windows (11)
# Use WSL or download from GitHub
# Or use pip:
pip install httpie

# Python pip (any OS)
pip install httpie

# HTTPie Desktop (GUI)
# Available for macOS, Windows, Linux
# Download from: https://httpie.io/app
```

### Setup

```bash
# Create config directory
mkdir -p ~/.config/httpie

# Config file location
# ~/.config/httpie/config.json
```

## Usage

### Basic Usage

```bash
# Simple GET request
http GET https://api.github.com/users/gregnazario

# Shorthand (default is GET)
http https://api.github.com/users/gregnazario

# POST request
http POST https://httpbin.org/post hello=world

# PUT request
http PUT https://httpbin.org/put name=John email=john@example.com

# DELETE request
http DELETE https://httpbin.org/delete

# HEAD request
http HEAD https://httpbin.org/get

# OPTIONS request
http OPTIONS https://httpbin.org/get
```

### Headers

```bash
# Add custom header
http GET https://api.github.com/users/gregnazario User-Agent:MyApp/1.0

# Multiple headers
http GET https://api.github.com/users/gregnazario \
  User-Agent:MyApp/1.0 \
  Accept:application/json

# Header with value containing spaces
http GET https://api.github.com/users/gregnazario \
  'Authorization:Bearer token123'

# Common headers
http GET https://api.example.com/data \
  'Content-Type:application/json' \
  'Accept:application/json'
```

### JSON Data

```bash
# Send JSON data (automatic)
http POST https://httpbin.org/post \
  name=John \
  email=john@example.com

# Send nested JSON
http POST https://httpbin.org/post \
  user[name]=John \
  user[email]=john@example.com \
  user[age]=30

# Send raw JSON
http POST https://httpbin.org/post \
  @data.json

# Send JSON from stdin
echo '{"name":"John","email":"john@example.com"}' | \
  http POST https://httpbin.org/post

# Pretty print JSON response
http GET https://api.github.com/users/gregnazario
```

### Form Data

```bash
# Send form data
http --form POST https://httpbin.org/post \
  name=John \
  email=john@example.com

# File upload (form)
http --form POST https://httpbin.org/post \
  file@~/Documents/file.pdf

# Multiple files
http --form POST https://httpbin.org/post \
  file1@~/doc1.pdf \
  file2@~/doc2.pdf

# Multipart form data
http --multipart POST https://httpbin.org/post \
  field=value \
  file@~/file.txt
```

### Authentication

```bash
# Basic auth
http -a username:password GET https://httpbin.org/basic-auth/user/pass

# Basic auth (prompt for password)
http -a username GET https://httpbin.org/basic-auth/user/pass

# Bearer token
http GET https://api.github.com/user \
  'Authorization:Bearer token123'

# Digest auth
http --auth-type=digest -a user:pass GET https://httpbin.org/digest-auth/auth/user/pass

# AWS Signature v4
http --auth-type aws --auth key:secret \
  GET https://s3.amazonaws.com/bucket/file
```

### Query Parameters

```bash
# Add query parameters
http GET https://httpbin.org/get \?\&page==2\&limit==10

# Shorthand
http 'https://httpbin.org/get?page=2&limit=10'

# Multiple parameters
http GET 'https://api.github.com/repos/gregnazario/dotfiles/issues?state=open&per_page=10'
```

### Sessions

```bash
# Create session (cookies persist)
http --session=./session.json GET https://httpbin.org/cookies/set/name/value

# Use session
http --session=./session.json GET https://httpbin.org/cookies

# Update session
http --session=./session.json POST https://httpbin.org/post name=John

# Named sessions
http --session=user1 GET https://api.example.com/data
http --session=user2 GET https://api.example.com/data
```

### Redirects

```bash
# Follow redirects (default: 30)
http GET https://httpbin.org/redirect/3

# Don't follow redirects
http --follow=false GET https://httpbin.org/redirect/1

# Custom redirect limit
http --max-redirects=5 GET https://httpbin.org/redirect/3
```

### Proxies

```bash
# HTTP proxy
http --proxy=http:http://proxy.example.com:8080 GET https://httpbin.org/get

# HTTPS proxy
http --proxy=https:http://proxy.example.com:8080 GET https://httpbin.org/get

# Both
http --proxy=http:http://proxy.example.com:8080 \
     --proxy=https:http://proxy.example.com:8080 \
     GET https://httpbin.org/get
```

### Output Options

```bash
# Show headers
http --headers GET https://httpbin.org/get

# Show body only
http --body GET https://httpbin.org/get

# Verbose output (show request)
http --verbose GET https://httpbin.org/get

# Pretty print (default)
http --pretty=all GET https://httpbin.org/get

# Colors
http --style=solarized GET https://httpbin.org/get

# Disable colors
http --style=none GET https://httpbin.org/get

# Download to file
http --download GET https://example.com/file.pdf

# Output to file
http GET https://api.example.com/data > output.json
```

### Advanced Features

```bash
# Request timeout
http --timeout=10 GET https://httpbin.org/delay/5

# Check status code
http --check-status GET https://httpbin.org/status/200

# Continue on error
http --check-status --ignore-stdin GET https://httpbin.org/status/404

# Offline mode (don't send)
http --offline POST https://api.example.com/data name=John

# Print request without sending
http --print=B GET https://httpbin.org/get

# Bridge mode (HTTP to WebSocket)
http --stream GET wss://echo.websocket.org
```

## Configuration

### ~/.config/httpie/config.json

```json
{
  "default_options": {
    "verify": false,
    "follow": false,
    "body": false,
    "download": false,
    "timeout": 30,
    "check_status": false,
    "style": "auto"
  }
}
```

### Environment Variables

```bash
# Default options
export HTTPIE_CONFIG_DIR=~/.config/httpie

# Proxy
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080

# Disable SSL verification
export HTTPIE_VERIFY=false

# Default style
export HTTPIE_STYLE=solarized
```

## Practical Examples

### API Testing

```bash
# GitHub API
http GET https://api.github.com/users/gregnazario
http GET https://api.github.com/users/gregnazario/repos
http GET https://api.github.com/repos/gregnazario/dotfiles/issues

# POST to API
http POST https://api.example.com/users \
  name=John \
  email=john@example.com \
  age=30

# PUT to API
http PUT https://api.example.com/users/1 \
  name=John \
  email=john@example.com

# DELETE from API
http DELETE https://api.example.com/users/1
```

### File Operations

```bash
# Download file
http --download GET https://example.com/file.pdf

# Upload file
http --form POST https://api.example.com/upload \
  file@~/Documents/file.pdf

# Upload with metadata
http --form POST https://api.example.com/upload \
  file@~/file.pdf \
  title='My Document' \
  author='John Doe'
```

### Debugging

```bash
# Show full request/response
http --verbose GET https://httpbin.org/get

# Show headers only
http --headers GET https://httpbin.org/get

# Check status code (exit on error)
http --check-status GET https://httpbin.org/status/200

# Test with proxy
http --proxy=http:http://proxy:8080 GET https://httpbin.org/get
```

### Authentication

```bash
# Bearer token
http GET https://api.github.com/user \
  'Authorization:Bearer ghp_token123'

# OAuth2
http POST https://api.example.com/oauth/token \
  grant_type=password \
  username=user \
  password=pass

# JWT
http GET https://api.example.com/data \
  'Authorization:Bearer eyJhbGciOiJIUzI1NiIs...'
```

### Session Management

```bash
# Login session
http --session=./user.json POST https://api.example.com/login \
  username=user \
  password=pass

# Use session (authenticated requests)
http --session=./user.json GET https://api.example.com/profile

# Update session
http --session=./user.json POST https://api.example.com/logout
```

### Webhooks

```bash
# Test webhook
http POST https://hooks.example.com/webhook \
  event=push \
  repository[name]=dotfiles \
  repository[owner]=gregnazario

# Slack webhook
http POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  text="Hello from HTTPie!" \
  channel="#general" \
  username="HTTPie" \
  icon_emoji=":ghost:"
```

## Tips

### Productivity

```bash
# Use session for authenticated APIs
http --session=./api.json GET https://api.example.com/data

# Use --check-status in scripts
http --check-status GET https://api.example.com/health || echo "Failed"

# Download files
http --download GET https://example.com/file.zip
```

### Debugging

```bash
# Use --verbose to see full request
http --verbose POST https://api.example.com/data name=John

# Use --headers to see response headers
http --headers GET https://api.example.com/data

# Test status codes
http --check-status GET https://api.example.com/status/200
```

### JSON Handling

```bash
# Pipe to jq for complex queries
http GET https://api.github.com/users/gregnazario/repos | \
  jq '.[] | {name, language}'

# Save JSON response
http GET https://api.example.com/data > response.json

# Send JSON from file
http POST https://api.example.com/data @data.json
```

### Sessions

```bash
# Use sessions for cookies
http --session=./session.json GET https://httpbin.org/cookies/set/user/John

# Session persists headers too
http --session=./session.json GET https://httpbin.org/headers

# Different sessions for different users
http --session=admin.json GET https://api.example.com/admin
http --session=user.json GET https://api.example.com/user
```

## Aliases

Add to shell config:

```bash
# HTTPie aliases
alias http-get='http GET'
alias http-post='http POST'
alias http-put='http PUT'
alias http-delete='http DELETE'
alias http-head='http HEAD'
alias http-options='http OPTIONS'

# Authenticated requests
alias http-auth='http --auth'
alias http-bearer="http --auth-type=bearer"

# Sessions
alias http-session='http --session=./session.json'
```

## Troubleshooting

### "Invalid method name"

```bash
# Use uppercase method names
http GET https://api.example.com/data

# Not:
http get https://api.example.com/data
```

### "Connection timeout"

```bash
# Increase timeout
http --timeout=60 GET https://api.example.com/slow-endpoint

# Check network
ping api.example.com
```

### "SSL verify failed"

```bash
# Disable SSL verification (not recommended)
http --verify=false GET https://api.example.com/data

# Or update CA certificates
sudo apt install ca-certificates
```

## Comparison

**HTTPie:**
- Python-based
- User-friendly
- JSON support
- Sessions
- Syntax highlighting
- Natural syntax

**curl:**
- C-based
- Universal
- More options
- Faster
- More complex
- Lower-level

**wget:**
- Download-focused
- Recursive downloads
- Simpler
- Less features
- Scripting-oriented

**HTTP Prompt:**
- Interactive mode
- REPL interface
- Built on HTTPie
- More interactive
- Complex queries

## Resources

- [HTTPie Website](https://httpie.io/)
- [HTTPie GitHub](https://github.com/httpie/httpie)
- [HTTPie Documentation](https://httpie.io/docs)
- [HTTPie Desktop](https://httpie.io/app)

---

**Last Updated**: 2025-03-14
