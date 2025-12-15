#!/bin/bash

# Bank of Pluto - Cleanup Script
# Removes all installed files and restores system to normal state

echo "🧹 Bank of Pluto - Cleanup"
echo "=========================="
echo ""
echo "⚠️  This will remove all installed files and configurations!"
echo ""

read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cancelled"
    exit 0
fi

echo ""
echo "🧹 Cleaning up..."

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Stop server first
bash stop.sh > /dev/null 2>&1

# Remove binaries
echo "  Removing binaries..."
make clean > /dev/null 2>&1
rm -rf bin/

# Linux cleanup
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "  Removing Apache configurations..."
    
    # Remove from 000-default.conf
    if [ -f "/etc/apache2/sites-available/000-default.conf" ]; then
        sudo sed -i '/# Buffer Overflow Vulnerable App Configuration/,/<\/Directory>/d' /etc/apache2/sites-available/000-default.conf 2>/dev/null
    fi
    
    # Remove virtual host
    sudo rm -f /etc/apache2/sites-available/buffer-overflow.conf 2>/dev/null
    sudo a2dissite buffer-overflow.conf 2>/dev/null
    
    # Remove installed files
    if [ -d "/var/www/html/buffer-overflow" ]; then
        echo "  Removing installed files..."
        sudo rm -rf /var/www/html/buffer-overflow
    fi
    
    # Reload Apache
    sudo systemctl reload apache2 2>/dev/null
fi

# Clean up processes
pkill -f "php.*8080" 2>/dev/null
pkill -f "httpd.*buffer-overflow" 2>/dev/null

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Note: Source code remains in this directory."
