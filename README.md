# Bank of Pluto - Buffer Overflow Vulnerable Web Application

This is an intentionally vulnerable banking web application designed for educational purposes to demonstrate buffer overflow vulnerabilities. This application is perfect for cybersecurity students learning about buffer overflow attacks in a controlled environment.

## Disclaimer 

**This application is intentionally vulnerable and should ONLY be used for educational purposes in a controlled environment. Do not deploy this application on public networks or use it with real credentials.**

## Installation & Setup

### Step 1: Install the rerequisites

**macOS:**
```bash
brew install php gcc make git
```

**Linux (Kali/Ubuntu):**
```bash
sudo apt update && sudo apt install -y apache2 php libapache2-mod-php gcc make git
```

### Step 2: Clone and Start

```bash
cd ~
git clone https://github.com/indranilroy99/Bank-of-Pluto.git
cd Bank-of-Pluto/buffer-overflow
./start.sh
```

**That's it!** Open `http://localhost:8080` in your browser.

### Step 3: Stop (when done)

```bash
cd ~/Bank-of-Pluto/buffer-overflow
./stop.sh
```

### Step 4: Cleanup (remove everything)

```bash
cd ~/Bank-of-Pluto/buffer-overflow
./cleanup.sh
```

---

**Simple Commands (run from `buffer-overflow` directory):**
- `./start.sh` - Start the application
- `./stop.sh` - Stop the application  
- `./cleanup.sh` - Remove everything and restore system

---

## Table of Contents

- [Overview](#overview)
- [Vulnerabilities](#vulnerabilities)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Stopping the Application](#stopping-the-application)
- [Cleanup](#cleanup)
- [Educational Objectives](#educational-objectives)
- [Troubleshooting](#troubleshooting)

## Overview

Bank of Pluto is a simple banking web application that demonstrates three types of buffer overflow vulnerabilities:

1. **Stack-based Buffer Overflow** - Transfer Funds feature
2. **Heap-based Buffer Overflow** - Transaction History feature
3. **Format String Vulnerability** - Account Statement feature

The application consists of:
- A modern web interface (HTML/CSS/JavaScript)
- Vulnerable C programs compiled without stack protection
- PHP CGI scripts that interface with the C binaries
- Web server configuration (Apache for Linux, PHP built-in server for macOS)

## Vulnerabilities

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

## Prerequisites

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

## Installation and Usage

### Step 1: Clone the Repository

```bash
cd ~
git clone https://github.com/indranilroy99/Bank-of-Pluto.git
cd Bank-of-Pluto/buffer-overflow
```

### Step 2: Run Setup (Optional but Recommended)

The setup script checks all dependencies and compiles the programs:

```bash
./setup.sh
```

This will:
- Detect your operating system (macOS or Linux)
- Check for all required dependencies (PHP, GCC, Make, Git)
- Install missing dependencies (with your permission)
- Compile the vulnerable C programs
- Set proper permissions

### Step 3: Start the Application

```bash
./start.sh
```

The server will start and display: `http://localhost:8080`

Open this URL in your browser.

### Step 4: Stop the Application

When finished testing:

```bash
./stop.sh
```

### Step 5: Cleanup (Optional)

To remove all installed files and restore your system:

```bash
./cleanup.sh
```

**Voila!** The application is now ready to use.

## Troubleshooting

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

## Additional Resources

- [OWASP Buffer Overflow](https://owasp.org/www-community/vulnerabilities/Buffer_Overflow)
- [Format String Vulnerabilities](https://owasp.org/www-community/attacks/Format_string_attack)
- [Stack vs Heap Memory](https://www.geeksforgeeks.org/stack-vs-heap-memory-allocation/)

## Contributing

Contributions to this project are welcome. 

---

** Happy Hacking **

