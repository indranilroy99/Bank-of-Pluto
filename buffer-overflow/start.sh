#!/bin/bash

# Bank of Pluto - Start Script
# Starts the web server and application

echo "🏦 Starting Bank of Pluto..."

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

# Check if binaries exist
if [ ! -d "bin" ] || [ ! -f "bin/stack_overflow" ]; then
    echo "⚠️  Binaries not found. Compiling..."
    make clean
    make
    if [ $? -ne 0 ]; then
        echo "❌ Compilation failed!"
        exit 1
    fi
fi

# Set permissions
chmod +x bin/* 2>/dev/null
chmod +x cgi-bin/*.php

if [ "$OS" == "mac" ]; then
    # macOS - Check if PHP is installed
    # Try to find PHP in common Homebrew locations
    if ! command -v php &> /dev/null; then
        if [ -f "/opt/homebrew/bin/php" ]; then
            export PATH="/opt/homebrew/bin:$PATH"
        elif [ -f "/usr/local/bin/php" ]; then
            export PATH="/usr/local/bin:$PATH"
        else
            echo "❌ PHP not found. Please install it using:"
            echo "   brew install php"
            exit 1
        fi
    fi
    
    # Start Apache using built-in server or httpd
    echo "✅ Starting PHP built-in server on macOS..."
    echo "📝 Server will run on: http://localhost:8080"
    echo "📝 Press Ctrl+C to stop the server"
    echo ""
    
    # Use PHP built-in server (simpler for Mac)
    php -S localhost:8080 -t . router.php 2>/dev/null || php -S localhost:8080 -t .
    
elif [ "$OS" == "linux" ]; then
    # Linux - Start Apache
    if ! command -v apache2 &> /dev/null; then
        echo "❌ Apache2 not found. Please install it using:"
        echo "   sudo apt install apache2"
        exit 1
    fi
    
    echo "✅ Starting Apache2..."
    sudo systemctl start apache2
    sudo systemctl status apache2 --no-pager
    
    if sudo systemctl is-active --quiet apache2; then
        echo ""
        echo "✅ Apache2 is running!"
        echo "📝 Open your browser and navigate to:"
        echo "   http://localhost/buffer-overflow/"
    else
        echo "❌ Failed to start Apache2"
        exit 1
    fi
fi

