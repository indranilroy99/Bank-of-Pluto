#!/bin/bash

# Bank of Pluto - Stop Script
# Stops the web server

echo "🛑 Stopping Bank of Pluto..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

if [ "$OS" == "mac" ]; then
    # macOS - Kill PHP server
    echo "🛑 Stopping PHP server..."
    
    # Find and kill PHP processes on port 8080
    PHP_PID=$(lsof -ti:8080)
    if [ ! -z "$PHP_PID" ]; then
        kill $PHP_PID
        echo "✅ PHP server stopped (PID: $PHP_PID)"
    else
        echo "ℹ️  No PHP server running on port 8080"
    fi
    
    # Also check for httpd
    HTTPD_PID=$(pgrep -f "httpd.*buffer-overflow")
    if [ ! -z "$HTTPD_PID" ]; then
        kill $HTTPD_PID
        echo "✅ Apache httpd stopped"
    fi
    
elif [ "$OS" == "linux" ]; then
    # Linux - Stop Apache
    echo "🛑 Stopping Apache2..."
    
    if sudo systemctl is-active --quiet apache2; then
        sudo systemctl stop apache2
        echo "✅ Apache2 stopped"
    else
        echo "ℹ️  Apache2 is not running"
    fi
fi

echo "✅ Bank of Pluto stopped successfully"

