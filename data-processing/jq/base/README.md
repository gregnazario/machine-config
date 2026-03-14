# jq - JSON Processor

jq is a lightweight and flexible command-line JSON processor.

## Features

### Core Features
- **JSON Parsing** - Parse and process JSON data
- **Filtering** - Extract specific data
- **Transformation** - Modify and reshape JSON
- **Color Output** - Syntax highlighting
- **Streaming** - Process large files efficiently
- **Functional** - Functional programming paradigm
- **Composable** - Build complex filters from simple ones

### Capabilities
- Map, filter, and reduce JSON arrays
- Transform JSON structures
- Query nested data
- Format and pretty-print JSON
- Validate JSON
- Convert between formats

## Installation

### Prerequisites

```bash
# Install jq
# macOS
brew install jq

# Fedora
sudo dnf install jq

# Ubuntu
sudo apt install jq

# Arch
sudo pacman -S jq

# Gentoo
sudo emerge dev-lang/jq

# Void
sudo xbps-install jq

# Alpine
sudo apk add jq

# FreeBSD
sudo pkg install jq

# Windows (11)
winget install jqlang.jq
# Or use scoop:
scoop install jq
```

### Setup

```bash
# No configuration needed
jq is ready to use after installation

# Create config file for aliases (optional)
mkdir -p ~/.config/jq
# Create .jqconfig with custom functions
```

## Usage

### Basic Usage

```bash
# Pretty-print JSON
cat file.json | jq '.'

# Pretty-print with color
jq '.' file.json

# Compact JSON (no whitespace)
jq -c '.' file.json

# Read from stdin
echo '{"name": "Greg"}' | jq '.'

# Read from file
jq '.' file.json

# Output without color
jq -C '.' file.json  # Force color
jq -M '.' file.json  # No color
```

### Selecting Fields

```bash
# Select single field
jq '.name' file.json

# Select nested field
jq '.user.name' file.json

# Select multiple fields
jq '.name, .age' file.json

# Select array element
jq '.users[0]' file.json

# Select array range
jq '.users[0:3]' file.json

# Select all array elements
jq '.users[]' file.json

# Select nested array elements
jq '.users[].name' file.json
```

### Filtering

```bash
# Filter array
jq '.users[] | select(.age > 25)' file.json

# Filter with multiple conditions
jq '.users[] | select(.age > 25 and .country == "US")' file.json

# Filter by existence
jq '.users[] | select(.email)' file.json

# Filter by regex
jq '.users[] | select(.name | test("^G"))' file.json

# Filter null values
jq '.[] | select(. != null)' file.json
```

### Transforming Data

```bash
# Add field
jq '. + {"status": "active"}' file.json

# Modify field
jq '.age = 30' file.json

# Delete field
jq 'del(.age)' file.json

# Rename field
jq '{new_name: .old_name}' file.json

# Map over array
jq '.users[] | {name: .name, email: .email}' file.json

# Create new object
jq '{name: .name, age: .age}' file.json

# Array to object
jq '{"users": .users}' file.json
```

### Arrays

```bash
# Create array
jq '[.name, .age]' file.json

# Array length
jq '.users | length' file.json

# Add to array
jq '.users + [{"name": "New"}]' file.json

# Reverse array
jq '.users | reverse' file.json

# Sort array
jq '.users | sort_by(.age)' file.json

# Group by
jq 'group_by(.age)' file.json

# Unique elements
jq '.users | map(.age) | unique' file.json

# Flatten arrays
jq 'flatten' file.json

# Filter array
jq '.users | map(select(.age > 25))' file.json
```

### String Operations

```bash
# String length
jq '.name | length' file.json

# Uppercase
jq '.name | ascii_upcase' file.json

# Lowercase
jq '.name | ascii_downcase' file.json

# String split
jq '.name | split(" ")' file.json

# String join
jq '.names | join(", ")' file.json

# Substring
jq '.name[0:3]' file.json

# String replace
jq '.name | sub("old"; "new")' file.json

# Trim
jq '.name | gsub("^\\s+|\\s+$"; "")' file.json
```

### Math Operations

```bash
# Addition
jq '.count + 1' file.json

# Subtraction
jq '.count - 1' file.json

# Multiplication
jq '.price * 1.1' file.json

# Division
jq '.total / 2' file.json

# Modulo
jq '.count % 2' file.json

# Minimum/maximum
jq '[.count1, .count2] | min' file.json
jq '[.count1, .count2] | max' file.json

# Sum
jq '[.prices] | add' file.json

# Average
jq '[.prices] | add / length' file.json

# Round
jq '.price | floor' file.json  # Round down
jq '.price | ceil' file.json   # Round up
jq '.price | round' file.json  # Round nearest
```

### Conditional Logic

```bash
# If-then-else
jq 'if .age > 18 then "adult" else "minor" end' file.json

# Ternary (alternative)
jq '.age > 18' file.json

# Multiple conditions
jq 'if .age < 13 then "child"
  elif .age < 18 then "teen"
  else "adult" end' file.json

# Null coalescing
jq '.name // "Unknown"' file.json

# AND/OR
jq '.age > 18 and .country == "US"' file.json
jq '.age < 18 or .age > 65' file.json
```

### Advanced Features

```bash
# Functions
jq 'def count: length; count' file.json

# Custom function
jq 'def add_one: . + 1; .age | add_one' file.json

# Reduce
jq 'reduce .users[] as $user (0; . + $user.age)' file.json

# ForEach
jq '.users[] | .age += 1' file.json

# Recursion
jq 'def walk(f): .
  | if type == "object" then map_values(walk(f))
  elif type == "array" then map(walk(f))
  else f end;
walk(. + 1)' file.json

# Paths
jq 'path(.users[0].name)' file.json

# Keys
jq 'keys' file.json

# Values
jq '.[] | values' file.json

# To entries (key-value pairs)
jq 'to_entries' file.json

# From entries
jq 'from_entries' file.json
```

### Input/Output

```bash
# Read multiple files
jq '.' file1.json file2.json

# Slurp multiple files into array
jq -s '.' *.json

# Raw output (string only)
jq -r '.name' file.json

# Null input (use with --arg)
jq -n '{name: $name}' --arg name "Greg"

# Arguments
jq '.users[] | select(.name == $name)' file.json --arg name "Greg"

# Raw input (read as string)
jq -R 'split("\n")' file.txt

# Slurp (read all input into array)
jq -s '.' file.json

# Exit codes
jq -e '.status == "ok"' file.json  # Exit 1 if false
```

### File Operations

```bash
# Validate JSON
jq '.' file.json > /dev/null && echo "Valid JSON"

# Minify JSON
jq -c '.' file.json > minified.json

# Format JSON
jq '.' file.json > formatted.json

# Merge multiple JSON files
jq -s 'add' file1.json file2.json > merged.json

# Extract field to file
jq '.field' file.json > field.json

# Sort JSON file by field
jq 'sort_by(.field)' file.json > sorted.json

# Filter JSON file
jq 'map(select(.status == "active"))' file.json > filtered.json
```

## Practical Examples

### API Responses

```bash
# Query API and parse JSON
curl -s https://api.github.com/users/gregnazario | jq '.'

# Extract specific field
curl -s https://api.github.com/users/gregnazario | jq '.name'

# Extract array element
curl -s https://api.github.com/users/gregnazario/repos | jq '.[0].name'

# Filter results
curl -s https://api.github.com/users/gregnazario/repos | \
  jq '[.[] | select(.fork == false)]'
```

### Configuration Files

```bash
# Extract value from config
jq '.database.host' config.json

# Update value
jq '.database.host = "localhost"' config.json > config.tmp.json
mv config.tmp.json config.json

# Merge config with defaults
jq '. * $defaults' config.json --argjson defaults '{"timeout": 30}'

# Remove sensitive data
jq 'del(.password, .api_key)' config.json > safe.json
```

### Log Analysis

```bash
# Parse JSON logs
cat logs.jsonl | jq '.'

# Count by field
cat logs.jsonl | jq '.level' | sort | uniq -c

# Filter logs
cat logs.jsonl | jq 'select(.level == "ERROR")'

# Extract specific fields
cat logs.jsonl | jq '{timestamp, level, message}'

# Calculate statistics
cat logs.jsonl | jq '.response_time' | jq -s 'add/length'
```

### Data Transformation

```bash
# CSV to JSON (with jq)
jq -R 'split(",") | {
  name: .[0],
  age: .[1],
  city: .[2]
}' file.csv

# JSON to CSV
jq -r '[.name, .age, .city] | @csv' file.json

# Flatten nested JSON
jq 'flatten' nested.json > flat.json

# Pivot data
jq '{(.id): .}' items.json > items-by-id.json
```

## Aliases

Add to shell config:

```bash
# Aliases for jq
alias jp='jq .'                    # Pretty print
alias jc='jq -c .'                  # Compact
alias jr='jq -r'                    # Raw output
alias jf='jq -f'                    # Filter from file
alias jca='jq --argjson'            # Pass JSON argument
alias jv='jq -e'                    # Validate (exit on false)

# Pretty print clipboard (macOS)
alias pjq='pbpaste | jq .'

# Pretty print clipboard (Linux with xclip)
alias xjq='xclip -o | jq .'
```

## Tips

### Color Output

```bash
# Always use color
alias jq='jq -C'

# Or set in .jqconfig
export JQ_COLORS='1;32:1;34:1;36:1;42:0;34:0;32:1;37:1;37:1;37'
```

### Compact Output

```bash
# Minify JSON for storage
jq -c '.' large.json > small.json

# Save space
```

### Validating JSON

```bash
# Validate JSON file
jq -e '.' file.json >/dev/null && echo "Valid" || echo "Invalid"

# Validate in shell script
if jq -e . >/dev/null 2>&1 <<<"$json"; then
  echo "Valid JSON"
fi
```

### Complex Queries

```bash
# Use pipe for complex queries
jq '.users[] | select(.age > 25) | {name, email}' file.json

# Break into steps
jq '.users[]' file.json | jq 'select(.age > 25)' | jq '{name, email}'
```

### Performance

```bash
# Use --stream for large files
jq --stream '.' huge.json

# Use --compact-output for faster processing
jq -c '.' large.json

# Limit output with --raw-output
jq -r '.field' file.json
```

## Troubleshooting

### "Cannot iterate over null"

```bash
# Check if field exists first
jq 'if .field then .field[] else empty end' file.json

# Or use // (null coalescing)
jq '.field // [] | .[]' file.json
```

### "Invalid path expression"

```bash
# Check JSON structure first
jq '.' file.json | head

# Use getpath for dynamic paths
jq 'getpath(["users", 0, "name"])' file.json
```

### Performance issues

```bash
# Use --stream mode
jq --stream '.' large.json

# Or use raw output
jq -c '.' large.json

# Filter early
jq '.data[] | select(.field)' file.json
```

## Comparison

**jq:**
- JSON only
- Functional
- Powerful
- Fast

**yq:**
- YAML, JSON, XML, CSV, TOML
- Similar syntax
- More formats

**jaq:**
- Rust implementation
- Faster
- Mostly compatible

**jid:**
- Interactive JSON explorer
- Easier to learn
- Less powerful

## Resources

- [jq Official](https://stedolan.github.io/jq/)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [jq Cookbook](https://github.com/stedolan/jq/wiki/Cookbook)
- [jq Online Playground](https://jqplay.org/)

---

**Last Updated**: 2025-03-14
