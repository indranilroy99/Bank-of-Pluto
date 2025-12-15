#!/bin/bash

# Bank of Pluto - Simple Cleanup Script
# Run this from anywhere: ./cleanup.sh

echo "🧹 Cleaning up Bank of Pluto..."
echo ""

# Find the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/buffer-overflow"

# Run the cleanup script
exec ./cleanup.sh

