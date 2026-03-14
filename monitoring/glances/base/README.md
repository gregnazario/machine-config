# glances System Monitor

Cross-platform system monitoring tool with Dracula theme.

## Features

### System Information
- **CPU** - CPU usage (user, system, iowait, steal)
- **Memory** - RAM usage (used, free, buffers, cached)
- **Swap** - Swap usage (used, free)
- **Load** - Load average (1, 5, 15 min)
- **Network** - Network interfaces (RX/TX)
- **Disk I/O** - Disk read/write rates
- **Filesystem** - Disk usage (used, free, %)
- **Processes** - Process list with resource usage
- **Sensors** - Temperature sensors (CPU, GPU, fans)
- **Battery** - Battery status (laptops)
- **Ports** - Network ports
- **Containers** - Docker containers

### Monitoring Features
- **Real-time updates** - Every 2 seconds (configurable)
- **Color-coded alerts** - Visual indicators for high resource usage
- **Process tree** - Hierarchical process view
- **Process filtering** - Filter processes by name, user, etc.
- **Interactive mode** - Sort by different columns
- **History** - Keep history of resource usage
- **Web server mode** - Run as web server for remote monitoring
- **Export** - Export to CSV or JSON

### Alerts
- **CPU** - Alert at 50%, 70%, 90% usage
- **Memory** - Alert at 50%, 70%, 90% usage
- **Swap** - Alert at 50%, 70%, 90% usage
- **Load** - Alert at 50%, 70%, 90% usage
- **Temperature** - Alert at 50°C, 70°C, 90°C

## Installation

### Prerequisites

```bash
# Install glances
# macOS
brew install glances

# Fedora
sudo dnf install glances

# Ubuntu
sudo apt install glances

# Arch
sudo pacman -S glances

# Python (via pip)
pip install glances

# Install optional dependencies:
# - psutil: System monitoring library
# - bat: Graph library
# - bottle: Web server mode

# For Docker stats:
pip install docker

# For GPU stats:
pip install nvidia-ml-py3
```

### Setup

```bash
# Copy config to Glances directory
mkdir -p ~/.config/glances
cp ~/.local/share/greg-config/monitoring/glances/base/glances.conf ~/.config/glances/

# Start Glances
glances

# Web server mode
glances -w

# Run on server and monitor remotely
# On server:
glances -w

# On client:
# Open browser to http://server:61208
```

## Usage

### Basic Usage

```bash
# Start Glances
glances

# Monitor remote server
glances -s@server

# Client mode
glances -c@server

# Disable process monitoring
glances --disable-process

# Monitor specific network interface
glances -i eth0

# Set update interval
glances -t 5

# Enable history
glances -H 60

# Export to CSV
glances --export csv --output-file glances.csv

# Export to JSON
glances --export json --output-file glances.json

# Web server mode
glances -w

# Web server with binding
glances -w -b 0.0.0.0

# Web server on specific port
glances -w -p 8080

# Check version
glances -V
```

### Interactive Commands

**While glances is running:**

- `q` - Quit
- `ESC` - Exit menu
- `Space` - Pause/Resume
- `Enter` - Edit filter
- `F5` - Refresh
- `1` - Switch to CPU view
- `2` - Switch to MEM view
- `3` - Switch to SWAP view
- `4` - Switch to LOAD view
- `5` - Switch to NETWORK view
- `6` - Switch to I/O view
- `7` - Switch to FS view
- `8` - Switch to TEMP view
- `9` - Switch to top processes view

**Sort order:**
- `a` - Sort automatically
- `p` - Sort by process name
- `c` - Sort by CPU usage
- `m` - Sort by memory usage
- `u` - Sort by user name
- `i` - Sort by I/O rate
- `t` - Sort by time
- `n` - Sort by thread name

**Filter:**
- `/` - Enter filter pattern
- `Enter` - Apply filter
- `Backspace` - Clear filter

**Kill process:**
- `k` - Kill process (with confirmation)

**Other commands:**
- `e` - Expand process tree
- `+` - Increase thread limit
- `-` - Decrease thread limit
- `?` - Show help

## Options

### Command-line Options

```
Usage: glances [options]

Options:
  -V, --version                    Show version and exit
  -h, --help                       Show this help message and exit
  -b, --byte                      Display network rate in byte/s
  -B, --bit                       Display network rate in bit/s
  -c, --check-fs [frequency]      Check filesystem every [frequency] seconds
  --disable-process               Disable process information
  --disable-sensors              Disable sensors (CPU, GPU, fans)
  --disable-network               Disable network
  --disable-diskio                Disable disk I/O
  --disable-dbio                   Disable database I/O (Berry)
  -t, --time [seconds]            Update time in seconds (default: 2)
  -w, --webserver [port]           Run Glances in web server mode
  -o, --output {csv,html,json}     Output file format
  -f, --file-filter               Set file filter pattern
  -q, --quiet                      Do not display interface
  -r, --reset-history              Reset history
  --export-csv                    Export statistics to CSV
  --export-json                   Export statistics to JSON
  --disable-history               Disable history
  --disable-irq                   Disable IRQ
  --disable-fs                    Disable filesystem
  --disable-swap                  Disable swap
  --disable-logs                  Disable logs
  --disable-process                Disable process
  --disable-ip                    Disable IP
  --enable-history                Enable history
  --enable-irq                    Enable IRQ
  --enable-fs                     Enable filesystem
  --enable-swap                   Enable swap
  --enable-logs                   Enable logs
  --enable-process                 Enable process
  --enable-ip                     Enable IP
  --hide-kernel-threads           Hide kernel threads
  --no-percpu                     Disable per-CPU stats
```

### Configuration File Options

```
[global]
# Update interval (in seconds)
refresh = 2

# Enable history
enable_history = True

# History timeout (in seconds)
time = 60

# Watch process changes
watch = True

[cpu]
# CPU alert threshold
cpu_alert = 50

[mem]
# Memory alert threshold
mem_alert = 50

[load]
# Load alert threshold
load_alert_5m = 50

[ports]
# Enable ports scanner
ports = False

# Ports refresh interval
ports_refresh = 60

[webserver]
# Web server mode
webserver = False

# Bind address
bind = "0.0.0.0"

# Port
port = 61208
```

## Configuration

### Theme

**Dracula Theme** configured with:
- Cyan for CPU
- Purple for nice
- Pink for iowait
- Yellow for system
- Red for critical
- Green for successful

### Graph Styles

Available graph styles:
- `|` - Vertical bars
- `·` - Dots
- `⡯⡾⡷⡾⡯` - Braille (most detailed)
- `⣿⣶⣴⣷⣾` - Block

## Dracula Theme Colors

The Dracula theme uses these colors:
- **Background**: #282a36
- **Current Line**: #44475a
- **Foreground**: #f8f8f2
- **Comment**: #6272a4
- **Cyan**: #8be9fd
- **Green**: #50fa7b
- **Orange**: #ffb86c
- **Pink**: #ff79c6
- **Purple**: #bd93f9
- **Red**: #ff5555
- **Yellow**: #f1fa8c

## Columns

### CPU
- User CPU usage
- System CPU usage
- I/O wait
- Nice
- Steal
- Total CPU usage

### Memory
- Total memory
- Used memory
- Free memory
- Active memory
- Buffers
- Cached

### Swap
- Total swap
- Used swap
- Free swap

### Load
- Load average (1 min)
- Load average (5 min)
- Load average (15 min)

### Network
- Interface
- RX (receive rate)
- TX (transmit rate)
- RX/s
- TX/s

### Disk I/O
- Disk name
- Read rate
- Write rate
- I/O wait

### Filesystem
- Mount point
- Total space
- Used space
- Free space
- Percent used

### Processes
- Process name
- User
- CPU%
- MEM%
- VIRT
- RES
- PID
- Command

### Sensors
- CPU temperature
- GPU temperature
- Fan speeds
- Battery percentage

## Monitoring Remote Servers

```bash
# Server mode
# On server:
glances -s

# On client:
glances -c@server

# Or use password
glances -c server:password@server
```

## Web Interface

```bash
# Start web server
glances -w

# Open browser
http://localhost:61208

# Or specific IP
http://192.168.1.100:61208

# With authentication
glances -w --username admin --password password
```

## Troubleshooting

### High CPU usage

1. Check update interval
2. Disable process monitoring
3. Disable network monitoring
4. Disable sensors

### Dependencies missing

```bash
# Install psutil
pip install psutil

# Install bottle for web server mode
pip install bottle

# Install optional dependencies
pip install bat graphing
```

### Sensors not working

1. Install `lm-sensors`
2. Run `sensors-detect`
3. Run `sensors`

### Docker stats not showing

```bash
# Install docker-py
pip install docker

# Check docker is running
docker ps
```

### Battery not showing

1. Install `bat`
2. Check if on laptop
3. Check battery reporting

## Comparison with btop

**Glances:**
- More detailed information
- Web interface
- Export capabilities
- More plugins

**btop:**
- Better UI
- Faster performance
- More interactive
- Terminal-only

Both are excellent! Choose based on your needs.

## Resources

- [Glances Documentation](https://nicolargo.github.io/glances/)
- [Glances GitHub](https://github.com/nicolargo/glances)
- [Dracula Theme](https://draculatheme.com/)

---

**Last Updated**: 2025-03-14
