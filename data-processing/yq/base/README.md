# yq - YAML/JSON/XML/TOML/CSV Processor

yq is a lightweight and portable command-line YAML, JSON, XML, TOML, and CSV processor.

## Features

### Supported Formats
- **YAML** - Native format, primary focus
- **JSON** - Bidirectional conversion
- **XML** - Parse and transform
- **TOML** - Parse and generate
- **CSV** - Read and write
- **Properties** - Java properties files

### Core Features
- **Multi-format** - Convert between formats
- **XPath-like queries** - Easy data extraction
- **Update in-place** - Modify files directly
- **Merge** - Combine multiple files
- **Validate** - Check file syntax
- **Sort** - Order data structures
- **Color output** - Syntax highlighting

## Installation

### Prerequisites

```bash
# Install yq (version 4+)
# macOS
brew install yq

# Fedora
sudo dnf install yq

# Ubuntu
sudo snap install yq
# Or download binary:
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

# Arch
sudo pacman -S yq

# Gentoo
sudo emerge dev-util/yq

# Void
sudo xbps-install yq

# Alpine
sudo apk add yq

# FreeBSD
sudo pkg install yq

# Windows (11)
winget install mikefarah.yq
# Or use scoop:
scoop bucket add extras
scoop install yq
```

### Setup

```bash
# Verify installation
yq --version

# No configuration needed
yq is ready to use after installation

# Create config file (optional)
mkdir -p ~/.config/yq
```

## Usage

### Basic Usage

```bash
# Read YAML file
yq eval '.' file.yaml

# Pretty print
yq eval '.' file.yaml

# Read specific field
yq eval '.field' file.yaml

# Read nested field
yq eval '.parent.child' file.yaml

# Read array element
yq eval '.users[0]' file.yaml

# Read array range
yq eval '.users[0:3]' file.yaml

# Read all array elements
yq eval '.users[]' file.yaml
```

### Selecting Fields

```bash
# Single field
yq eval '.name' file.yaml

# Nested field
yq eval '.database.host' file.yaml

# Multiple fields
yq eval '.name, .age' file.yaml

# Array element
yq eval '.items[0]' file.yaml

# Last element
yq eval '.items[-1]' file.yaml

# All array elements
yq eval '.items[]' file.yaml

# Nested array
yq eval '.users[].name' file.yaml
```

### Updating Data

```bash
# Update field
yq eval '.field = "value"' file.yaml

# Update nested field
yq eval '.database.host = "localhost"' file.yaml

# Add field
yq eval '. + {"new": "value"}' file.yaml

# Delete field
yq eval 'del(.field)' file.yaml

# Update array element
yq eval '.items[0] = "new"' file.yaml

# Add to array
yq eval '.items += "new"' file.yaml

# Delete array element
yq eval 'del(.items[0])' file.yaml
```

### In-place Editing

```bash
# Update file in-place
yq eval -i '.field = "value"' file.yaml

# Update multiple fields
yq eval -i '.field1 = "val1" | .field2 = "val2"' file.yaml

# Create backup
yq eval -i'.backup' '.field = "value"' file.yaml

# Update multiple files
for file in *.yaml; do
  yq eval -i '.version = "2.0"' "$file"
done
```

### Arrays

```bash
# Array length
yq eval '.items | length' file.yaml

# Reverse array
yq eval '.items | reverse' file.yaml

# Sort array
yq eval '.items | sort' file.yaml

# Sort by field
yq eval '.items | sort_by(.age)' file.yaml

# Filter array
yq eval '.items[] | select(.age > 25)' file.yaml

# Map over array
yq eval '.items[] | .name' file.yaml

# Create array
yq eval '[.name, .age]' file.yaml

# Unique elements
yq eval '.items | unique' file.yaml

# Flatten
yq eval '.nested | flatten' file.yaml
```

### Filtering

```bash
# Filter by value
yq eval '.users[] | select(.age > 25)' file.yaml

# Filter by multiple conditions
yq eval '.users[] | select(.age > 25 and .country == "US")' file.yaml

# Filter by existence
yq eval '.users[] | select(.email)' file.yaml

# Filter by regex
yq eval '.users[] | select(.name | test("^G"))' file.yaml

# Filter null values
yq eval '.[] | select(. != null)' file.yaml
```

### String Operations

```bash
# String length
yq eval '.name | length' file.yaml

# Uppercase
yq eval '.name | upcase' file.yaml

# Lowercase
yq eval '.name | downcase' file.yaml

# String split
yq eval '.name | split(" ")' file.yaml

# String join
yq eval '.names | join(", ")' file.yaml

# Substring
yq eval '.name[0:3]' file.yaml

# String replace
yq eval '.name | sub("old", "new")' file.yaml

# Trim
yq eval '.name | sub("^\\s+", "") | sub("\\s+$", "")' file.yaml

# String contains
yq eval '.name | contains("Greg")' file.yaml
```

### Math Operations

```bash
# Addition
yq eval '.count + 1' file.yaml

# Subtraction
yq eval '.count - 1' file.yaml

# Multiplication
yq eval '.price * 1.1' file.yaml

# Division
yq eval '.total / 2' file.yaml

# Modulo
yq eval '.count % 2' file.yaml

# Minimum/maximum
yq eval 'min(.counts)' file.yaml
yq eval 'max(.counts)' file.yaml

# Sum
yq eval '.counts | add' file.yaml

# Average
yq eval '(.counts | add) / (.counts | length)' file.yaml

# Round
yq eval '.price | floor' file.yaml  # Round down
yq eval '.price | ceil' file.yaml   # Round up
```

### Conditional Logic

```bash
# If-then-else
yq eval 'if .age > 18 then "adult" else "minor" end' file.yaml

# Multiple conditions
yq eval 'if .age < 13 then "child"
  elif .age < 18 then "teen"
  else "adult" end' file.yaml

# Null coalescing
yq eval '.name // "Unknown"' file.yaml

# AND/OR
yq eval '.age > 18 and .country == "US"' file.yaml
yq eval '.age < 18 or .age > 65' file.yaml
```

### Multi-document YAML

```bash
# Read all documents
yq eval '...' file.yaml

# Read specific document
yq eval 'selectDocumentIndex 0' file.yaml

# Update specific document
yq eval -i 'selectDocumentIndex 0 | .field = "value"' file.yaml

# Split documents
yq eval -s '.' file.yaml

# Merge documents
yq eval -s '.' file1.yaml file2.yaml > merged.yaml
```

### Format Conversion

```bash
# YAML to JSON
yq eval -o=json '.' file.yaml > file.json

# JSON to YAML
yq eval -o=yaml '.' file.json > file.yaml

# YAML to XML
yq eval -o=xml '.' file.yaml > file.xml

# XML to YAML
yq eval -o=yaml '.' file.xml > file.yaml

# YAML to TOML
yq eval -o=toml '.' file.yaml > file.toml

# TOML to YAML
yq eval -o=yaml '.' file.toml > file.yaml

# YAML to CSV
yq eval -o=csv '.' file.yaml > file.csv

# CSV to YAML
yq eval -o=yaml '.' file.csv > file.yaml
```

### Merging Files

```bash
# Merge two YAML files
yq eval -n 'load("file1.yaml") * load("file2.yaml")' > merged.yaml

# Merge multiple files
yq eval -n 'load("file1.yaml") * load("file2.yaml") * load("file3.yaml")' > merged.yaml

# Concatenate arrays
yq eval -n 'load("file1.yaml") + load("file2.yaml")' > merged.yaml

# Update with override file
yq eval -n 'load("base.yaml") * load("override.yaml")' > result.yaml
```

### Advanced Operations

```bash
# Recursively update
yq eval '(.. | select(key == "old")) |= "new"' file.yaml

# Delete all null values
yq eval 'del(.. | select(. == null))' file.yaml

# Sort keys
yq eval 'sort_keys(.)' file.yaml

# Paths to field
yq eval '.. | select(key == "field") | path' file.yaml

# Group by
yq eval 'group_by(.age)' file.yaml

# Map values
yq eval 'map_values(.age += 1)' file.yaml

# Convert to map
yq eval '.[] | {(key): .}' file.yaml
```

### Shell Variables

```bash
# Pass variable to yq
name="Greg"
yq eval ".name = \"$name\"" file.yaml

# Use environment variable
export AGE=30
yq eval '.age = env(AGE)' file.yaml

# Multiple variables
yq eval ".name = \"$NAME\" | .age = $AGE" file.yaml --argjson AGE 30

# Pass entire JSON object
json_obj='{"key": "value"}'
yq eval ".config |= $json" file.yaml --argjson json "$json_obj"
```

### Practical Examples

### Kubernetes Configuration

```bash
# Update deployment image
yq eval -i '.spec.template.spec.containers[0].image = "myapp:v2.0"' deployment.yaml

# Update replicas
yq eval -i '.spec.replicas = 3' deployment.yaml

# Change namespace
yq eval -i '.metadata.namespace = "production"' deployment.yaml

# Add label
yq eval -i '.metadata.labels.env = "prod"' deployment.yaml

# Merge config
yq eval -n 'load("base.yaml") * load("override.yaml")' > final.yaml
```

### CI/CD Configuration

```bash
# Update version in .gitlab-ci.yml
yq eval -i '.variables.VERSION = "1.2.3"' .gitlab-ci.yml

# Enable stage
yq eval -i '.stages += "deploy"' .gitlab-ci.yml

# Update Docker image
yq eval -i '.image = "docker:latest"' .gitlab-ci.yml
```

### Application Configuration

```bash
# Update database host
yq eval -i '.database.host = "localhost"' config.yaml

# Update port
yq eval -i '.server.port = 8080' config.yaml

# Enable feature flag
yq eval -i '.features.newUI = true' config.yaml

# Update array
yq eval -i '.allowedOrigins += "https://example.com"' config.yaml
```

### GitHub Actions

```bash
# Update action version
yq eval -i '.jobs.build.steps[0].uses = "actions/checkout@v4'" workflow.yaml

# Add environment variable
yq eval -i '.env.TESTING = "true"' workflow.yaml

# Enable job
yq eval -i '.jobs.deploy.enabled = true' workflow.yaml
```

### Data Processing

```bash
# Filter logs
yq eval '.[] | select(.level == "ERROR")' logs.yaml

# Calculate statistics
yq eval '.prices | add' data.yaml
yq eval '(.prices | add) / (.prices | length)' data.yaml

# Group data
yq eval 'group_by(.category)' items.yaml

# Transform data
yq eval '.[] | {name, email: .contacts.email}' users.yaml
```

## Aliases

Add to shell config:

```bash
# Aliases for yq
alias yqy='yq eval -o=yaml'    # YAML output
alias yqj='yq eval -o=json'    # JSON output
alias yqx='yq eval -o=xml'     # XML output
alias yqt='yq eval -o=toml'    # TOML output
alias yqc='yq eval -o=csv'     # CSV output
alias yqi='yq eval -i'         # In-place edit

# YAML to JSON
alias y2j='yq eval -o=json'

# JSON to YAML
alias j2y='yq eval -o=yaml'

# Pretty print YAML
alias ypp='yq eval "." -C'
```

## Tips

### Pretty Print

```bash
# Use color output
alias yq='yq -C'

# Format output
yq eval -C '.' file.yaml

# Compact output
yq eval -c '.' file.yaml
```

### Validation

```bash
# Validate YAML
yq eval '.' file.yaml >/dev/null && echo "Valid"

# Validate in shell script
if yq eval '.' file.yaml >/dev/null 2>&1; then
  echo "Valid YAML"
fi
```

### Safe Updates

```bash
# Always test first
yq eval '.field = "value"' file.yaml | yq eval '.'

# Then update in-place
yq eval -i '.field = "value"' file.yaml

# Create backup
yq eval -i'.backup' '.field = "value"' file.yaml
```

### Multi-document

```bash
# Process all documents
yq eval '...' multi.yaml

# Update all documents
yq eval -i 'selectDocumentIndex * | .version = "2.0"' multi.yaml

# Split documents
yq eval -s '.' multi.yaml
```

### Performance

```bash
# Use eval for single operations
yq eval '.' file.yaml

# Use eval-all for multi-document
yq eval-all '.' file1.yaml file2.yaml

# Limit output
yq eval '.items[0:10]' file.yaml
```

## Troubleshooting

### "Cannot index array with string"

```bash
# Check if field is array or object
yq eval '.field | type' file.yaml

# Handle both cases
yq eval '.field | if type == "array" then .[0] else . end' file.yaml
```

### "Unknown escape sequence"

```bash
# Use single quotes for strings
yq eval '.field = '\''value\''' file.yaml

# Or use double quotes correctly
yq eval '.field = "value"' file.yaml
```

### Performance issues

```bash
# Use specific paths instead of ..
yq eval '.parent.child.grandchild' file.yaml

# Filter early
yq eval '.items[] | select(.field)' file.yaml

# Use raw output when possible
yq eval -r '.field' file.yaml
```

## Comparison

**yq:**
- Multi-format (YAML, JSON, XML, CSV, TOML, Properties)
- Similar syntax to jq
- Good for YAML (primary focus)
- Written in Go

**jq:**
- JSON only
- More powerful for JSON
- Faster
- Written in C

**yaml:**
- Go YAML library
- Not as user-friendly
- Lower-level

**dasel:**
- Multi-format
- Different syntax (selector-based)
- Less popular

## Resources

- [yq GitHub](https://github.com/mikefarah/yq)
- [yq Documentation](https://mikefarah.gitbook.io/yq/)
- [yq Playground](https://mikefarah.gitbook.io/yq/)

---

**Last Updated**: 2025-03-14
