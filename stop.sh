#!/bin/bash

# Bank of Pluto - Simple Stop Script
# Run this from anywhere: ./stop.sh

echo "🛑 Stopping Bank of Pluto..."
echo ""

# Find the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/buffer-overflow"

# Run the stop script
exec ./stop.sh

