#!/bin/bash

# Bank of Pluto - Stop Script
# Stops the web server

echo "🛑 Stopping Bank of Pluto..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - Kill PHP server
    PHP_PID=$(lsof -ti:8080 2>/dev/null)
    if [ ! -z "$PHP_PID" ]; then
        kill $PHP_PID 2>/dev/null
        echo "✅ Server stopped"
    else
        echo "ℹ️  No server running"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - Stop Apache
    if sudo systemctl is-active --quiet apache2 2>/dev/null; then
        sudo systemctl stop apache2
        echo "✅ Apache2 stopped"
    else
        echo "ℹ️  Apache2 is not running"
    fi
fi

echo "✅ Done"
