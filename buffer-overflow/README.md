# 🏦 SecureBank - Buffer Overflow Vulnerable Web Application

An intentionally vulnerable banking web application designed for educational purposes to demonstrate buffer overflow vulnerabilities. This application is perfect for cybersecurity students learning about buffer overflow attacks in a controlled environment.

## ⚠️ Disclaimer

**This application is intentionally vulnerable and should ONLY be used for educational purposes in a controlled environment. Do not deploy this application on public networks or use it with real credentials.**

## 📋 Table of Contents

- [Overview](#overview)
- [Vulnerabilities](#vulnerabilities)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Hosting on Kali Linux](#hosting-on-kali-linux)
- [Educational Objectives](#educational-objectives)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

SecureBank is a simple banking web application that demonstrates three types of buffer overflow vulnerabilities:

1. **Stack-based Buffer Overflow** - Transfer Funds feature
2. **Heap-based Buffer Overflow** - Transaction History feature
3. **Format String Vulnerability** - Account Statement feature

The application consists of:
- A modern web interface (HTML/CSS/JavaScript)
- Vulnerable C programs compiled without stack protection
- PHP CGI scripts that interface with the C binaries
- Apache web server configuration

## 🔓 Vulnerabilities

### 1. Stack Buffer Overflow (`stack_overflow.c`)
- **Location**: Transfer Funds page
- **Vulnerability**: Uses `strcpy()` without bounds checking
- **Buffer Size**: 50 bytes
- **Impact**: Can overwrite return addresses and execute arbitrary code

### 2. Heap Buffer Overflow (`heap_overflow.c`)
- **Location**: Transaction History page
- **Vulnerability**: Unsafe memory allocation and copying
- **Buffer Size**: 100 bytes
- **Impact**: Can corrupt heap metadata and potentially execute code

### 3. Format String Vulnerability (`format_string.c`)
- **Location**: Account Statement page
- **Vulnerability**: User input directly passed to `printf()`
- **Impact**: Can read/write arbitrary memory locations

## 📦 Prerequisites

Before you begin, ensure you have the following installed on your Kali Linux machine:

- **Apache2** web server
- **PHP** (with CLI support)
- **GCC** compiler
- **Git** (for cloning)
- **Make** utility

Install prerequisites:
```bash
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php gcc make git
```

## 🚀 Installation

### Step 1: Clone the Repository

```bash
cd ~
git clone <your-github-repo-url>
cd custom-vuln-apps/buffer-overflow
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
- `-z execstack` (makes stack executable)
- `-g` (debug symbols)
- `-O0` (no optimization)

### Step 3: Set Permissions

```bash
make install
chmod +x cgi-bin/*.php
```

## 🌐 Hosting on Kali Linux

### Step 1: Copy Files to Web Directory

```bash
# Option 1: Copy to default Apache directory
sudo cp -r ~/custom-vuln-apps/buffer-overflow /var/www/html/buffer-overflow

# Option 2: Create symbolic link (recommended for development)
sudo ln -s ~/custom-vuln-apps/buffer-overflow /var/www/html/buffer-overflow
```

### Step 2: Configure Apache

#### Enable Required Modules

```bash
sudo a2enmod cgi
sudo a2enmod rewrite
sudo systemctl restart apache2
```

#### Configure Apache for CGI

Edit the Apache configuration:

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

Add the following inside the `<VirtualHost *:80>` block:

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

#### Alternative: Create a Virtual Host (Optional)

```bash
sudo cp apache-config.conf /etc/apache2/sites-available/buffer-overflow.conf
sudo nano /etc/apache2/sites-available/buffer-overflow.conf
# Edit the paths to match your installation
sudo a2ensite buffer-overflow.conf
sudo systemctl reload apache2
```

### Step 3: Update Binary Paths

If you copied files to `/var/www/html/buffer-overflow`, the paths should work. If you used a different location, update the paths in the PHP files:

```bash
sudo nano /var/www/html/buffer-overflow/cgi-bin/transfer.php
# Verify the path: __DIR__ . '/../bin/stack_overflow'
```

### Step 4: Test the Application

1. Start Apache (if not running):
```bash
sudo systemctl start apache2
sudo systemctl status apache2
```

2. Open your browser and navigate to:
```
http://localhost/buffer-overflow/
```

You should see the SecureBank homepage.

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

### Issue: Apache not serving PHP files

**Solution**:
```bash
sudo a2enmod php
sudo systemctl restart apache2
```

### Issue: CGI scripts not executing

**Solution**:
```bash
# Check if CGI module is enabled
sudo a2enmod cgi
sudo systemctl restart apache2

# Check file permissions
chmod +x /var/www/html/buffer-overflow/cgi-bin/*.php
```

### Issue: Binaries not found

**Solution**:
```bash
# Recompile
cd /var/www/html/buffer-overflow
make clean
make

# Check paths in PHP files
grep -r "bin/" cgi-bin/
```

### Issue: Permission denied errors

**Solution**:
```bash
# Set proper ownership
sudo chown -R www-data:www-data /var/www/html/buffer-overflow

# Set execute permissions
sudo chmod +x /var/www/html/buffer-overflow/bin/*
sudo chmod +x /var/www/html/buffer-overflow/cgi-bin/*.php
```

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

