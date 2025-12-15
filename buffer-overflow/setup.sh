#!/bin/bash

# Bank of Pluto Setup Script
# This script helps set up the vulnerable web application on Kali Linux

echo "🏦 Bank of Pluto - Buffer Overflow Vulnerable App Setup"
echo "=================================================="
echo ""

# Check if running as root for certain operations
if [ "$EUID" -eq 0 ]; then 
    echo "⚠️  Please don't run this script as root. It will ask for sudo when needed."
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check prerequisites
print_status "Checking prerequisites..."

# Check for GCC
if ! command -v gcc &> /dev/null; then
    print_error "GCC not found. Installing..."
    sudo apt update && sudo apt install -y gcc
else
    print_status "GCC found"
fi

# Check for Make
if ! command -v make &> /dev/null; then
    print_error "Make not found. Installing..."
    sudo apt update && sudo apt install -y make
else
    print_status "Make found"
fi

# Check for Apache
if ! command -v apache2 &> /dev/null; then
    print_error "Apache2 not found. Installing..."
    sudo apt update && sudo apt install -y apache2
else
    print_status "Apache2 found"
fi

# Check for PHP
if ! command -v php &> /dev/null; then
    print_error "PHP not found. Installing..."
    sudo apt update && sudo apt install -y php libapache2-mod-php
else
    print_status "PHP found"
fi

# Compile vulnerable programs
print_status "Compiling vulnerable C programs..."
make clean
if make; then
    print_status "Compilation successful!"
else
    print_error "Compilation failed!"
    exit 1
fi

# Set permissions
print_status "Setting permissions..."
chmod +x bin/* 2>/dev/null
chmod +x cgi-bin/*.php
make install

# Get current directory
CURRENT_DIR=$(pwd)
print_status "Current directory: $CURRENT_DIR"

# Ask user about installation location
echo ""
print_warning "Choose installation method:"
echo "1) Copy to /var/www/html/buffer-overflow (recommended)"
echo "2) Create symbolic link to current directory"
echo "3) Skip (manual setup)"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        print_status "Copying files to /var/www/html/buffer-overflow..."
        sudo rm -rf /var/www/html/buffer-overflow
        sudo cp -r "$CURRENT_DIR" /var/www/html/buffer-overflow
        sudo chown -R www-data:www-data /var/www/html/buffer-overflow
        INSTALL_DIR="/var/www/html/buffer-overflow"
        ;;
    2)
        print_status "Creating symbolic link..."
        sudo rm -f /var/www/html/buffer-overflow
        sudo ln -s "$CURRENT_DIR" /var/www/html/buffer-overflow
        sudo chown -R www-data:www-data "$CURRENT_DIR"
        INSTALL_DIR="/var/www/html/buffer-overflow"
        ;;
    3)
        print_warning "Skipping file installation. Please configure manually."
        INSTALL_DIR="$CURRENT_DIR"
        ;;
    *)
        print_error "Invalid choice. Skipping file installation."
        INSTALL_DIR="$CURRENT_DIR"
        ;;
esac

# Configure Apache
print_status "Configuring Apache..."

# Enable required modules
sudo a2enmod cgi 2>/dev/null
sudo a2enmod rewrite 2>/dev/null

# Check if configuration already exists
if ! grep -q "buffer-overflow" /etc/apache2/sites-available/000-default.conf 2>/dev/null; then
    print_status "Adding Apache configuration..."
    
    # Backup original config
    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.backup
    
    # Add configuration
    sudo tee -a /etc/apache2/sites-available/000-default.conf > /dev/null <<EOF

# Buffer Overflow Vulnerable App Configuration
<Directory $INSTALL_DIR>
    Options +ExecCGI
    AddHandler cgi-script .php
    AllowOverride None
    Require all granted
</Directory>

<Directory $INSTALL_DIR/cgi-bin>
    Options +ExecCGI
    AddHandler cgi-script .php
    AllowOverride None
    Require all granted
</Directory>
EOF
    
    print_status "Apache configuration added"
else
    print_warning "Apache configuration already exists"
fi

# Restart Apache
print_status "Restarting Apache..."
sudo systemctl restart apache2

# Check Apache status
if sudo systemctl is-active --quiet apache2; then
    print_status "Apache is running"
else
    print_error "Apache failed to start. Please check: sudo systemctl status apache2"
fi

# Final instructions
echo ""
echo "=================================================="
print_status "Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Open your browser and navigate to:"
echo "   http://localhost/buffer-overflow/"
echo ""
echo "2. If you see the Bank of Pluto homepage, setup is successful!"
echo ""
echo "3. Read README.md for exploitation instructions"
echo ""
print_warning "Remember: This is an intentionally vulnerable application!"
print_warning "Use only for educational purposes in a controlled environment."
echo ""

