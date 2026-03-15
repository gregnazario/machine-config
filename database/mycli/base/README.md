# mycli - MySQL CLI with Autocomplete

mycli is a command-line interface for MySQL and MariaDB with auto-completion and syntax highlighting.

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

### Advantages Over mysql
- Better auto-completion
- Syntax highlighting
- More user-friendly
- Smart completion (context-aware)
- Better table formatting
- Vertical output for wide tables
- Modern keybindings
- Works with MariaDB

## Installation

### Prerequisites

```bash
# Install mycli
# macOS
brew install mycli

# Fedora
sudo dnf install mycli

# Ubuntu
sudo apt install mycli

# Arch
sudo pacman -S mycli

# Gentoo
sudo emerge dev-python/mycli

# Void
sudo xbps-install mycli

# Alpine
sudo apk add mycli

# FreeBSD
sudo pkg install mycli

# Windows (11)
# Use WSL or install via pip:
pip install mycli

# pip (any OS)
pip install mycli

# With MariaDB support
pip install mycli[mariadb]
```

### Setup

```bash
# No configuration needed
mycli is ready to use after installation

# Optional: Create config directory
mkdir -p ~/.config/mycli
```

## Usage

### Basic Usage

```bash
# Connect to default database (current user)
mycli

# Connect to specific database
mycli mydb

# Connect with specific user
mycli -h localhost -u root mydb

# Connect with specific host and port
mycli -h db.example.com -P 3306 -u user mydb

# Connect with password
mycli -h localhost -u root -p mydb

# Execute single command
mycli -c "SELECT * FROM users;" mydb

# Execute SQL file
mycli -f script.sql mydb

# Connect using login path (MySQL config)
mycli --login-path=client
```

### Interactive Mode

```bash
# Once connected:
\?                    # Show help
\q                    # Quit
\d                    # List databases
SHOW DATABASES;       # List databases (MySQL way)

# Show tables
SHOW TABLES;
# or
SHOW TABLES FROM mydb;

# Describe table
DESCRIBE users;
# or
DESC users;

# Show users
SELECT user, host FROM mysql.user;

# Run SQL query
SELECT * FROM users LIMIT 10;

# Multi-line query
SELECT *
FROM users
WHERE active = 1
LIMIT 10;
```

### Special Commands

```bash
# System commands
\!                    # Execute shell command
\! ls -la             # Run ls -la

# Status commands
STATUS;               # Show server status

# Database commands
SHOW DATABASES;       # List databases
USE mydb;             # Switch database

# Table commands
SHOW TABLES;          # List tables
SHOW TABLES FROM mydb;
SHOW FULL TABLES;     # With table type

# Describe commands
DESCRIBE users;
DESC users;
SHOW COLUMNS FROM users;
SHOW CREATE TABLE users;

# Process list
SHOW PROCESSLIST;

# Variables
SHOW VARIABLES;

# Output formatting
\T [table|vertical|csv|json]  # Change output format
\x                    # Toggle expanded output

# Edit query
\e                    # Open query in editor
\e filename           # Edit file in editor

# Timing
\timing               # Toggle query timing

# Source file
source script.sql;
# or
\. script.sql
```

### Auto-Completion

```bash
# Table completion
SELECT * FROM use[TAB]  # Completes to: users

# Column completion
SELECT id, na[TAB]      # Completes to: name

# JOIN completion
SELECT * FROM users JOIN or[TAB]  # Shows: orders

# Subquery completion
SELECT * FROM users WHERE id IN (SELECT id FROM or[TAB]  # Shows: orders

# Keyword completion
SEL[TAB]                # Completes to: SELECT

# Function completion
SELECT no[TAB]          # Shows: now(), nullif(), etc.

# Database completion
USE my[TAB]             # Shows all databases starting with 'my'
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

### ~/.config/mycli/config

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

### MySQL Login Path (Recommended)

```bash
# Setup secure login path
# Store credentials securely in ~/.mylogin.cnf

mysql_config_editor set --login-path=client \
  --host=localhost \
  --user=root \
  --password

# Use with mycli
mycli --login-path=client

# Setup for production
mysql_config_editor set --login-path=production \
  --host=prod-db.example.com \
  --user=appuser \
  --password

# Connect to production
mycli --login-path=production mydb
```

### Environment Variables

```bash
# Default connection parameters
export MYSQL_HOST=localhost
export MYSQL_TCP_PORT=3306
export MYSQL_USER=root
export MYSQL_PWD=password  # Not recommended, use login path
```

## Practical Examples

### Daily Development

```bash
# Connect to local database
mycli mydb

# List tables
SHOW TABLES;

# Describe table
DESC users;

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
# Connect to mysql database
mycli mysql

# List all databases
SHOW DATABASES;

# Connect to specific database
USE production;

# List users
SELECT user, host FROM mysql.user;

# Create database
CREATE DATABASE myapp;

# Create user
CREATE USER 'myapp_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON myapp.* TO 'myapp_user'@'localhost';
FLUSH PRIVILEGES;

# Show grants
SHOW GRANTS FOR 'myapp_user'@'localhost';
```

### Data Analysis

```bash
# Connect to analytics database
mycli analytics

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

# Explain query
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';
```

### Query Optimization

```bash
# Enable timing
\timing

# Enable EXPLAIN
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';

# Check indexes
SHOW INDEX FROM users;

# Table size
SELECT
  table_name,
  table_rows,
  ROUND(data_length / 1024 / 1024, 2) AS 'Data (MB)',
  ROUND(index_length / 1024 / 1024, 2) AS 'Index (MB)'
FROM information_schema.tables
WHERE table_schema = 'mydb'
ORDER BY data_length DESC;
```

### Backup and Restore

```bash
# Export schema
mysqldump -u root -p --no-data mydb > schema.sql

# Export data
\T csv
\o data.csv
SELECT * FROM users;
\o

# Import data
LOAD DATA INFILE 'data.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSEED '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Run SQL script
mycli -f script.sql mydb
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

# Use vertical output for wide tables
\x

# Use MySQL login path for secure connections
mysql_config_editor set --login-path=client --host=localhost --user=root --password
```

### Security

```bash
# Use login path instead of passwords
# Don't use -p in scripts

# Limit user permissions
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'app_user'@'localhost';

# Don't use root for applications
# Create application-specific users

# Use SSL for remote connections
mycli --ssl -h remote-db.com -u user mydb
```

### Performance

```bash
# Use EXPLAIN
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';

# Add indexes
CREATE INDEX idx_email ON users(email);

# Limit results for testing
SELECT * FROM users LIMIT 10;

# Use transactions
START TRANSACTION;
-- Your queries
COMMIT;
-- or ROLLBACK;
```

### Integration

```bash
# Works with MySQL tools
mysqldump, mysqlcheck, mysqladmin

# Use with Docker
docker exec -it mysql-container mycli

# Use with MariaDB
mycli works with MariaDB too!
```

## Aliases

Add to shell config:

```bash
# mycli aliases
alias my='mycli'                 # Short alias
alias mylocal='mycli localhost'  # Local connection
alias myprod='mycli --login-path=production'  # Production database
alias mytest='mycli test-db'     # Test database
alias mydev='mycli dev-db'       # Dev database
```

## Troubleshooting

### "Can't connect to MySQL server"

```bash
# Check MySQL is running
sudo systemctl status mysql

# Start MySQL
sudo systemctl start mysql

# Check port
netstat -an | grep 3306
```

### "Access denied for user"

```bash
# Use -p flag to prompt for password
mycli -u root -p

# Or use login path
mysql_config_editor set --login-path=client --host=localhost --user=root --password

# Check user exists
SELECT user, host FROM mysql.user;
```

### "Unknown database"

```bash
# List databases
SHOW DATABASES;

# Create database
CREATE DATABASE mydb;

# Or use mycli to create
mycli -u root -p -e "CREATE DATABASE mydb;"
```

### Auto-completion not working

```bash
# Check connection
mycli mydb

# Try typing slowly and press TAB
# Wait for completion

# Check if table exists
SHOW TABLES;
```

## Comparison

**mycli:**
- Python-based
- Smart auto-completion
- Syntax highlighting
- Modern UI
- Active development
- Better UX
- Works with MariaDB

**mysql:**
- Native MySQL tool
- Installed with MySQL
- More features
- More stable
- Less user-friendly
- Standard tool

**MariaDB CLI:**
- Native MariaDB tool
- Similar to mysql
- MariaDB-specific features
- Less modern

**MySQL Workbench:**
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

### Large Scripts

```bash
# Execute large script
mycli -f large_script.sql mydb

# With output to file
mycli -f script.sql mydb > output.txt
```

### Batch Operations

```bash
# Multiple statements
mycli -e "
CREATE DATABASE test;
USE test;
CREATE TABLE users (id INT);
SHOW TABLES;
"
```

## MariaDB Support

```bash
# mycli works with MariaDB
mycli -h mariadb-server.com -u user mydb

# MariaDB-specific features
# All MariaDB SQL features work

# Performance schema
SELECT * FROM performance_schema.events_statements_summary_by_digest;
```

## Resources

- [mycli Website](https://www.mycli.net)
- [mycli GitHub](https://github.com/dbcli/mycli)
- [mycli Documentation](https://www.mycli.net/learn)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)

---

**Last Updated**: 2025-03-14
