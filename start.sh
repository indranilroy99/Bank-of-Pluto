#!/bin/bash

# Bank of Pluto - Simple Start Script
# Run this from anywhere: ./start.sh

echo "🏦 Starting Bank of Pluto..."
echo ""

# Find the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/buffer-overflow"

# Run the start script
exec ./start.sh

