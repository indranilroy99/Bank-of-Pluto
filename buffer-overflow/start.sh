#!/bin/bash

# Bank of Pluto - Start Script
# Starts the web server and application

echo "🏦 Bank of Pluto - Starting Server..."
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Detect OS and find PHP
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    # macOS - Find PHP in Homebrew locations
    if [ -f "/opt/homebrew/bin/php" ]; then
        PHP_CMD="/opt/homebrew/bin/php"
    elif [ -f "/usr/local/bin/php" ]; then
        PHP_CMD="/usr/local/bin/php"
    elif command -v php &> /dev/null; then
        PHP_CMD="php"
    else
        echo "❌ PHP not found!"
        echo ""
        echo "Please install PHP using Homebrew:"
        echo "   brew install php"
        exit 1
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    PHP_CMD="php"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Check if PHP works
if ! $PHP_CMD --version &> /dev/null; then
    echo "❌ PHP is not working properly"
    exit 1
fi

# Check if binaries exist, compile if needed
if [ ! -d "bin" ] || [ ! -f "bin/stack_overflow" ]; then
    echo "📦 Compiling vulnerable programs..."
    make clean > /dev/null 2>&1
    if ! make > /dev/null 2>&1; then
        echo "❌ Compilation failed! Please check if GCC is installed."
        exit 1
    fi
    echo "✅ Compilation complete"
fi

# Set permissions
chmod +x bin/* 2>/dev/null
chmod +x cgi-bin/*.php 2>/dev/null

# Check if port 8080 is already in use
if lsof -ti:8080 &> /dev/null; then
    echo "⚠️  Port 8080 is already in use"
    echo "   Stopping existing server..."
    lsof -ti:8080 | xargs kill 2>/dev/null
    sleep 1
fi

if [ "$OS" == "mac" ]; then
    echo "✅ Starting PHP server..."
    echo ""
    echo "🌐 Server running at: http://localhost:8080"
    echo "📝 Press Ctrl+C to stop the server"
    echo ""
    
    # Start PHP built-in server
    $PHP_CMD -S localhost:8080 -t . router.php
    
elif [ "$OS" == "linux" ]; then
    # Linux - Start Apache
    if ! command -v apache2 &> /dev/null; then
        echo "❌ Apache2 not found. Please install it:"
        echo "   sudo apt install apache2 php libapache2-mod-php"
        exit 1
    fi
    
    echo "✅ Starting Apache2..."
    sudo systemctl start apache2
    
    if sudo systemctl is-active --quiet apache2; then
        echo ""
        echo "✅ Apache2 is running!"
        echo "🌐 Open your browser: http://localhost/buffer-overflow/"
    else
        echo "❌ Failed to start Apache2"
        exit 1
    fi
fi
