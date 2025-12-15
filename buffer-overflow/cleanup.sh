#!/bin/bash

# Bank of Pluto - Cleanup Script
# Removes all installed files and restores system to normal state

echo "🧹 Bank of Pluto - Cleanup Script"
echo "=================================="
echo ""
echo "⚠️  WARNING: This will remove all installed files and configurations!"
echo "This includes:"
echo "  - Web server configurations"
echo "  - Installed files in web directories"
echo "  - Compiled binaries"
echo ""

read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cleanup cancelled"
    exit 0
fi

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo ""
echo "🧹 Starting cleanup..."

# Stop the server first
echo "1. Stopping web server..."
bash stop.sh 2>/dev/null

# Remove compiled binaries
echo "2. Removing compiled binaries..."
make clean 2>/dev/null
rm -rf bin/

# Remove Apache configurations (Linux)
if [ "$OS" == "linux" ]; then
    echo "3. Removing Apache configurations..."
    
    # Remove from 000-default.conf
    if [ -f "/etc/apache2/sites-available/000-default.conf" ]; then
        if grep -q "buffer-overflow" /etc/apache2/sites-available/000-default.conf 2>/dev/null; then
            echo "   Removing configuration from 000-default.conf..."
            sudo sed -i '/# Buffer Overflow Vulnerable App Configuration/,/<\/Directory>/d' /etc/apache2/sites-available/000-default.conf
        fi
    fi
    
    # Remove virtual host if exists
    if [ -f "/etc/apache2/sites-available/buffer-overflow.conf" ]; then
        echo "   Removing virtual host configuration..."
        sudo a2dissite buffer-overflow.conf 2>/dev/null
        sudo rm -f /etc/apache2/sites-available/buffer-overflow.conf
    fi
    
    # Remove installed files
    if [ -d "/var/www/html/buffer-overflow" ]; then
        echo "4. Removing installed files from /var/www/html/buffer-overflow..."
        sudo rm -rf /var/www/html/buffer-overflow
    fi
    
    # Reload Apache
    if command -v apache2 &> /dev/null; then
        echo "5. Reloading Apache configuration..."
        sudo systemctl reload apache2 2>/dev/null
    fi
fi

# macOS cleanup
if [ "$OS" == "mac" ]; then
    echo "3. macOS cleanup complete (no system-wide changes made)"
fi

# Clean up any remaining processes
echo "6. Cleaning up any remaining processes..."
pkill -f "php.*8080" 2>/dev/null
pkill -f "httpd.*buffer-overflow" 2>/dev/null

# Remove any backup files
echo "7. Removing backup files..."
rm -f /etc/apache2/sites-available/000-default.conf.backup 2>/dev/null

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "The following have been removed:"
echo "  ✓ Compiled binaries"
echo "  ✓ Web server configurations"
echo "  ✓ Installed files in web directories"
echo ""
echo "Note: The source code in this directory remains intact."
echo "You can run 'make' again to recompile if needed."

