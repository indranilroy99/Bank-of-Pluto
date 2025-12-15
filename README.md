# 🏦 Bank of Pluto - Buffer Overflow Vulnerable Web Application

An intentionally vulnerable banking web application designed for educational purposes to demonstrate buffer overflow vulnerabilities. This application is perfect for cybersecurity students learning about buffer overflow attacks in a controlled environment.

## ⚠️ Disclaimer

**This application is intentionally vulnerable and should ONLY be used for educational purposes in a controlled environment. Do not deploy this application on public networks or use it with real credentials.**

## 📋 Table of Contents

- [Overview](#overview)
- [Vulnerabilities](#vulnerabilities)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Stopping the Application](#stopping-the-application)
- [Cleanup](#cleanup)
- [Educational Objectives](#educational-objectives)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

Bank of Pluto is a simple banking web application that demonstrates three types of buffer overflow vulnerabilities:

1. **Stack-based Buffer Overflow** - Transfer Funds feature
2. **Heap-based Buffer Overflow** - Transaction History feature
3. **Format String Vulnerability** - Account Statement feature

The application consists of:
- A modern web interface (HTML/CSS/JavaScript)
- Vulnerable C programs compiled without stack protection
- PHP CGI scripts that interface with the C binaries
- Web server configuration (Apache for Linux, PHP built-in server for macOS)

## 🔓 Vulnerabilities

### 1. Stack Buffer Overflow (`buffer-overflow/src/stack_overflow.c`)
- **Location**: Transfer Funds page
- **Vulnerability**: Uses `strcpy()` without bounds checking
- **Buffer Size**: 50 bytes
- **Impact**: Can overwrite return addresses and execute arbitrary code

### 2. Heap Buffer Overflow (`buffer-overflow/src/heap_overflow.c`)
- **Location**: Transaction History page
- **Vulnerability**: Unsafe memory allocation and copying
- **Buffer Size**: 100 bytes
- **Impact**: Can corrupt heap metadata and potentially execute code

### 3. Format String Vulnerability (`buffer-overflow/src/format_string.c`)
- **Location**: Account Statement page
- **Vulnerability**: User input directly passed to `printf()`
- **Impact**: Can read/write arbitrary memory locations

## 📦 Prerequisites

### For macOS:

Install Homebrew (if not already installed):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install required packages:
```bash
brew install php gcc make git
```

### For Linux (Kali/Ubuntu/Debian):

```bash
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php gcc make git
```

## 🚀 Installation

### Step 1: Clone the Repository

```bash
cd ~
git clone https://github.com/indranilroy99/Bank-of-Pluto.git
cd Bank-of-Pluto/buffer-overflow
```

### Step 2: Compile the Vulnerable Programs

The Makefile compiles the C programs with disabled security features to make exploitation easier:

```bash
make
```

This will create three binaries in the `bin/` directory:
- `bin/stack_overflow`
- `bin/heap_overflow`
- `bin/format_string`

**Note**: The programs are compiled with:
- `-fno-stack-protector` (disables stack canaries)
- `-z execstack` (Linux only - makes stack executable)
- `-g` (debug symbols)
- `-O0` (no optimization)

### Step 3: Set Permissions

```bash
make install
chmod +x cgi-bin/*.php
chmod +x *.sh
```

## 🚀 Running the Application

### Quick Start (Recommended)

Navigate to the buffer-overflow directory and run the start script:

```bash
cd buffer-overflow
./start.sh
```

This script will:
- Detect your operating system (macOS or Linux)
- Compile binaries if needed
- Start the appropriate web server
- Display the URL to access the application

### Manual Setup

#### For macOS:

Navigate to the buffer-overflow directory:
```bash
cd buffer-overflow
```

The start script uses PHP's built-in server:

```bash
php -S localhost:8080 -t . router.php
```

Then open your browser to: `http://localhost:8080`

#### For Linux:

1. **Navigate to buffer-overflow directory**:
```bash
cd ~/Bank-of-Pluto/buffer-overflow
```

2. **Copy files to web directory**:
```bash
sudo cp -r ~/Bank-of-Pluto/buffer-overflow /var/www/html/buffer-overflow
```

3. **Configure Apache**:
```bash
sudo a2enmod cgi
sudo a2enmod rewrite
```

Edit Apache configuration:
```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

Add inside `<VirtualHost *:80>`:
```apache
<Directory /var/www/html/buffer-overflow>
    Options +ExecCGI
    AddHandler cgi-script .php
    AllowOverride None
    Require all granted
</Directory>

<Directory /var/www/html/buffer-overflow/cgi-bin>
    Options +ExecCGI
    AddHandler cgi-script .php
    AllowOverride None
    Require all granted
</Directory>
```

4. **Set permissions**:
```bash
sudo chown -R www-data:www-data /var/www/html/buffer-overflow
sudo chmod +x /var/www/html/buffer-overflow/bin/*
sudo chmod +x /var/www/html/buffer-overflow/cgi-bin/*.php
```

5. **Start Apache**:
```bash
sudo systemctl start apache2
sudo systemctl status apache2
```

6. **Access the application**:
Open your browser to: `http://localhost/buffer-overflow/`

## 🛑 Stopping the Application

### Quick Stop

Navigate to the buffer-overflow directory and run the stop script:

```bash
cd buffer-overflow
./stop.sh
```

### Manual Stop

#### For macOS:

Find and kill the PHP server process:
```bash
lsof -ti:8080 | xargs kill
```

Or press `Ctrl+C` if running in terminal.

#### For Linux:

Stop Apache:
```bash
sudo systemctl stop apache2
```

## 🧹 Cleanup

After completing the lab, you can completely remove all installed files and configurations using the cleanup script:

```bash
cd buffer-overflow
./cleanup.sh
```

This script will:
- Stop the web server
- Remove compiled binaries
- Remove Apache configurations (Linux)
- Remove installed files from web directories
- Restore system to normal state

**Note**: The cleanup script will ask for confirmation before proceeding.

### Manual Cleanup

If you prefer to clean up manually:

#### For macOS:

```bash
cd buffer-overflow
# Stop the server
./stop.sh

# Remove binaries
make clean
rm -rf bin/
```

#### For Linux:

```bash
# Stop Apache
sudo systemctl stop apache2

# Remove configurations
sudo sed -i '/# Buffer Overflow Vulnerable App Configuration/,/<\/Directory>/d' /etc/apache2/sites-available/000-default.conf
sudo rm -f /etc/apache2/sites-available/buffer-overflow.conf
sudo a2dissite buffer-overflow.conf 2>/dev/null

# Remove installed files
sudo rm -rf /var/www/html/buffer-overflow

# Reload Apache
sudo systemctl reload apache2

# Remove binaries
cd ~/Bank-of-Pluto/buffer-overflow
make clean
rm -rf bin/
```

## 📚 Educational Objectives

After completing this lab, students should understand:

1. **Buffer Overflow Concepts**:
   - Difference between stack and heap overflows
   - How unsafe functions (`strcpy`, `gets`, `sprintf`) cause vulnerabilities
   - Memory layout (stack vs heap)

2. **Format String Vulnerabilities**:
   - How format specifiers work
   - Memory reading through format strings
   - Memory writing through `%n`

3. **Exploitation Techniques**:
   - Basic buffer overflow exploitation
   - Understanding program crashes
   - Memory corruption concepts

4. **Defense Mechanisms**:
   - Stack canaries (disabled in this app)
   - ASLR (Address Space Layout Randomization)
   - Non-executable stack (disabled in this app)
   - Safe alternatives (`strncpy`, `snprintf`)

## 🔧 Troubleshooting

### Issue: Binaries not compiling on macOS

**Solution**: macOS uses clang by default. Make sure you have GCC installed:
```bash
brew install gcc
```

### Issue: Apache not serving PHP files (Linux)

**Solution**:
```bash
sudo a2enmod php
sudo systemctl restart apache2
```

### Issue: CGI scripts not executing

**Solution**:
```bash
# Linux
sudo a2enmod cgi
sudo systemctl restart apache2
cd buffer-overflow
chmod +x cgi-bin/*.php

# macOS - Make sure router.php is in the buffer-overflow directory
```

### Issue: Permission denied errors (Linux)

**Solution**:
```bash
sudo chown -R www-data:www-data /var/www/html/buffer-overflow
sudo chmod +x /var/www/html/buffer-overflow/bin/*
sudo chmod +x /var/www/html/buffer-overflow/cgi-bin/*.php
```

### Issue: Port 8080 already in use (macOS)

**Solution**: Kill the process using port 8080:
```bash
lsof -ti:8080 | xargs kill
```

Or modify `buffer-overflow/start.sh` to use a different port.

### Issue: Program crashes immediately

**This is expected behavior!** The programs are intentionally vulnerable. Crashes indicate successful buffer overflow attempts.

## 📝 Additional Resources

- [OWASP Buffer Overflow](https://owasp.org/www-community/vulnerabilities/Buffer_Overflow)
- [Format String Vulnerabilities](https://owasp.org/www-community/attacks/Format_string_attack)
- [Stack vs Heap Memory](https://www.geeksforgeeks.org/stack-vs-heap-memory-allocation/)

## 👥 Contributing

This is an educational project. Feel free to:
- Report issues
- Suggest improvements
- Add more vulnerability examples
- Improve documentation

## 📄 License

This project is for educational purposes only. Use responsibly and only in controlled environments.

## 🙏 Acknowledgments

Inspired by OWASP Juice Shop and other intentionally vulnerable applications designed for security education.

---

**Happy Learning! Stay Secure! 🔒**

