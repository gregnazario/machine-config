# pgcli - PostgreSQL CLI with Autocomplete

pgcli is a command-line interface for PostgreSQL with auto-completion and syntax highlighting.

## Features

### Core Features
- **Auto-Completion** - Smart context-aware completion
- **Syntax Highlighting** - Colorized SQL output
- **Multi-line** - Multi-line query editing
- **Smart Completion** - Suggests tables, columns, functions
- **Vertical Output** - Automatic vertical mode for wide results
- **Paging** - Less-style paging for large results
- **Timing** - Query execution time
- **Favorite Queries** - Save and reuse queries
- **OS Integration** - Works with tab completion in your shell

### Advantages Over psql
- Better auto-completion
- Syntax highlighting
- More user-friendly
- Smart completion (context-aware)
- Better table formatting
- Vertical output for wide tables
- Modern keybindings

## Installation

### Prerequisites

```bash
# Install pgcli
# macOS
brew install pgcli

# Fedora
sudo dnf install pgcli

# Ubuntu
sudo apt install pgcli

# Arch
sudo pacman -S pgcli

# Gentoo
sudo emerge dev-python/pgcli

# Void
sudo xbps-install pgcli

# Alpine
sudo apk add pgcli

# FreeBSD
sudo pkg install pgcli

# Windows (11)
# Use WSL or install via pip:
pip install pgcli

# pip (any OS)
pip install pgcli

# With PostgreSQL support
pip install pgcli[pgspecial]
```

### Setup

```bash
# No configuration needed
pgcli is ready to use after installation

# Optional: Create config directory
mkdir -p ~/.config/pgcli
```

## Usage

### Basic Usage

```bash
# Connect to default database (current user)
pgcli

# Connect to specific database
pgcli mydb

# Connect with specific user
pgcli -h localhost -u postgres mydb

# Connect with specific host and port
pgcli -h db.example.com -p 5432 -u user mydb

# Connect with password
pgcli -h localhost -u user -W mydb

# Execute single command
pgcli -c "SELECT * FROM users;" mydb

# Execute SQL file
pgcli -f script.sql mydb
```

### Interactive Mode

```bash
# Once connected:
\?                    # Show help
\q                    # Quit
\l                    # List databases
\dt                   # List tables
\d table_name         # Describe table
\du                   # List users
\dn                   # List schemas

# Run SQL query
SELECT * FROM users LIMIT 10;

# Multi-line query
SELECT *
FROM users
WHERE active = true
LIMIT 10;
```

### Special Commands

```bash
# \d commands
\d                    # List relations
\dt                   # List tables
\di                   # List indexes
\dv                   # List views
\ds                   # List sequences
\df                   # List functions
\d+ table_name        # Detailed table info

# \c commands
\c db_name            # Connect to database
\c db_name user host  # Connect with specific parameters

# \l command
\l                    # List all databases

# \u command
\du                   # List all users

# Schema commands
\dn                   # List schemas

# Timing
\timing               # Toggle query timing

# Output formatting
\T [table|vertical|csv|json]  # Change output format
\x                    # Toggle expanded output

# Edit query
\e                    # Open query in editor
\e filename           # Edit file in editor

# Watch query
\watch SELECT COUNT(*) FROM users;

# Favorite queries
\fav save myquery     # Save current query
\fav list             # List favorites
\fav myquery          # Run favorite query
```

### Auto-Completion

```bash
# Table completion
SELECT * FROM use[TAB]  # Completes to: users

# Column completion
SELECT id, na[TAB]      # Completes to: name

# JOIN completion
SELECT * FROM users JOIN or[TAB]  # Shows: orders, organizations

# Subquery completion
SELECT * FROM users WHERE id IN (SELECT id FROM or[TAB]  # Shows: orders

# Keyword completion
SEL[TAB]                # Completes to: SELECT

# Function completion
SELECT no[TAB]          # Shows: now(), nullif(), etc.
```

### Output Formats

```bash
# Table format (default)
SELECT * FROM users;

# Vertical output (for wide tables)
\T vertical
SELECT * FROM users;

# JSON output
\T json
SELECT * FROM users;

# CSV output
\T csv
SELECT * FROM users;

# Expanded output (vertical rows)
\x
SELECT * FROM users;
```

## Configuration

### ~/.config/pgcli/config

```ini
# Syntax highlighting
syntax_highlight = True

# Show less verbose table borders
less_verbose = True

# Auto-vertical output for wide tables
auto_vertical_output = True

# Enable query timing
timing_enabled = True

# Multi-line mode
multiline = True

# Pager for long output
pager = long

# Show null values as
null_string = '<null>'

# Border style
# Options: ascii, double, heavy, light, minimal, none
border = ascii

# Keybinding style
# Options: emacs, vi
key_bindings = emacs

# Alert on destructive operations
destructive_warning = True
```

### Environment Variables

```bash
# Default connection parameters
export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=mydb
export PGPASSWORD=password

# Use ~/.pgpass for secure password storage
# Format: hostname:port:database:username:password
echo "localhost:5432:*:postgres:mypassword" > ~/.pgpass
chmod 600 ~/.pgpass
```

## Practical Examples

### Daily Development

```bash
# Connect to local database
pgcli mydb

# List tables
\dt

# Describe table
\d users

# Query with timing
\timing
SELECT COUNT(*) FROM users;

# Export query to CSV
\T csv
SELECT * FROM users;
# Copy output to file
```

### Database Administration

```bash
# Connect to postgres database
pgcli postgres

# List all databases
\l

# Connect to specific database
\c production

# List users
\du

# Create database
CREATE DATABASE myapp;

# Create user
CREATE USER myapp_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE myapp TO myapp_user;
```

### Data Analysis

```bash
# Connect to analytics database
pgcli analytics

# Complex query with JOIN
SELECT u.name, COUNT(o.id) as order_count
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.name
ORDER BY order_count DESC
LIMIT 10;

# Export to JSON
\T json
\o output.json
SELECT * FROM users;
\o

# Save favorite query
\fav save top_users
```

### Query Optimization

```bash
# Enable timing
\timing

# Enable EXPLAIN
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'user@example.com';

# Check indexes
\di

# Table size
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Backup and Restore

```bash
# Export schema
pgcli -c "\d mytable" mydb > schema.sql

# Export data
\T csv
\o data.csv
SELECT * FROM users;
\o

# Import data
\copy users FROM 'data.csv' CSV HEADER;

# Run SQL script
pgcli -f script.sql mydb
```

## Tips

### Productivity

```bash
# Use auto-completion
# Type partial and press TAB

# Multi-line queries
# Use Shift+Enter for new line

# Edit long queries in editor
\e

# Save commonly used queries as favorites
\fav save myquery

# Use vertical output for wide tables
\x
```

### Security

```bash
# Use ~/.pgpass for passwords
# Don't use -W in scripts

# Limit user permissions
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA public TO readonly_user;

# Use connection strings carefully
# Don't hardcode passwords
```

### Performance

```bash
# Use EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM users;

# Limit results for testing
SELECT * FROM users LIMIT 10;

# Use transactions
BEGIN;
-- Your queries
COMMIT;
-- or ROLLBACK;
```

### Integration

```bash
# Works with PostgreSQL tools
pg_dump, pg_restore, psql

# Use with Docker
docker exec -it postgres-container pgcli

# Use with connection strings
pgcli postgresql://user:password@localhost:5432/mydb
```

## Aliases

Add to shell config:

```bash
# pgcli aliases
alias pg='pgcli'                 # Short alias
alias pglocal='pgcli localhost'  # Local connection
alias pgprod='pgcli prod-db'     # Production database
alias pgtest='pgcli test-db'     # Test database
alias pgdev='pgcli dev-db'       # Dev database
```

## Troubleshooting

### "connection refused"

```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL
sudo systemctl start postgresql

# Check port
netstat -an | grep 5432
```

### "password authentication failed"

```bash
# Use -W flag to prompt for password
pgcli -W mydb

# Or use ~/.pgpass file
echo "localhost:5432:mydb:user:password" > ~/.pgpass
chmod 600 ~/.pgpass
```

### "database does not exist"

```bash
# List databases
\l

# Create database
createdb mydb

# Or use pgcli to create
pgcli postgres -c "CREATE DATABASE mydb;"
```

### Auto-completion not working

```bash
# Check connection
pgcli mydb

# Try typing slowly and press TAB
# Wait for completion

# Check if table exists
\dt
```

## Comparison

**pgcli:**
- Python-based
- Smart auto-completion
- Syntax highlighting
- Modern UI
- Active development
- Better UX

**psql:**
- Native PostgreSQL tool
- Installed with PostgreSQL
- More features
- More stable
- Less user-friendly
- Standard tool

**pgAdmin:**
- GUI tool
- More features
- Visual query builder
- Slower
- Desktop app

**DBeaver:**
- Cross-platform GUI
- Multiple databases
- Feature-rich
- Heavy
- Desktop app

## Advanced Usage

### Custom Prompts

```python
# In config file
# prompt = "\\u@\\h:\\d> "
# Shows: user@host:database>
```

### Watch Command

```bash
# Monitor query
\watch SELECT COUNT(*) FROM users;

# Every 5 seconds
\watch 5 SELECT COUNT(*) FROM active_users;
```

### Large Scripts

```bash
# Execute large script
pgcli -f large_script.sql mydb

# With output to file
pgcli -f script.sql mydb > output.txt
```

## Resources

- [pgcli Website](https://pgcli.com)
- [pgcli GitHub](https://github.com/dbcli/pgcli)
- [pgcli Documentation](https://pgcli.readthedocs.io/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Last Updated**: 2025-03-14
