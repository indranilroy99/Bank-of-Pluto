#!/bin/bash

# Bank of Pluto - Comprehensive Setup Script
# Checks all dependencies and OS before installation

echo "Bank of Pluto - Setup and Dependency Check"
echo "==========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please don't run this script as root. It will ask for sudo when needed."
    exit 1
fi

# Detect OS
echo "Step 1: Detecting Operating System..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    print_status "Detected: macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    print_status "Detected: Linux"
else
    print_error "Unsupported OS: $OSTYPE"
    exit 1
fi
echo ""

# Check dependencies
echo "Step 2: Checking Dependencies..."
echo "-----------------------------------"

MISSING_DEPS=0

# Check Git
if command -v git &> /dev/null; then
    print_status "Git: $(git --version | head -n1)"
else
    print_error "Git: Not found"
    MISSING_DEPS=1
fi

# Check GCC
if command -v gcc &> /dev/null; then
    print_status "GCC: $(gcc --version | head -n1)"
else
    print_error "GCC: Not found"
    MISSING_DEPS=1
fi

# Check Make
if command -v make &> /dev/null; then
    print_status "Make: $(make --version | head -n1)"
else
    print_error "Make: Not found"
    MISSING_DEPS=1
fi

# Check PHP
PHP_CMD=""
if [ "$OS" == "mac" ]; then
    if [ -f "/opt/homebrew/bin/php" ]; then
        PHP_CMD="/opt/homebrew/bin/php"
        print_status "PHP: $($PHP_CMD --version | head -n1)"
    elif [ -f "/usr/local/bin/php" ]; then
        PHP_CMD="/usr/local/bin/php"
        print_status "PHP: $($PHP_CMD --version | head -n1)"
    elif command -v php &> /dev/null; then
        PHP_CMD="php"
        print_status "PHP: $(php --version | head -n1)"
    else
        print_error "PHP: Not found"
        MISSING_DEPS=1
    fi
else
    if command -v php &> /dev/null; then
        PHP_CMD="php"
        print_status "PHP: $(php --version | head -n1)"
    else
        print_error "PHP: Not found"
        MISSING_DEPS=1
    fi
fi

# Linux-specific: Check Apache
if [ "$OS" == "linux" ]; then
    if command -v apache2 &> /dev/null; then
        print_status "Apache2: $(apache2 -v | head -n1)"
    else
        print_error "Apache2: Not found"
        MISSING_DEPS=1
    fi
fi

echo ""

# Install missing dependencies
if [ $MISSING_DEPS -eq 1 ]; then
    print_warning "Some dependencies are missing."
    echo ""
    
    if [ "$OS" == "mac" ]; then
        echo "To install missing dependencies on macOS, run:"
        echo "  brew install php gcc make git"
        echo ""
        read -p "Would you like to install missing dependencies now? (y/n): " install_choice
        if [ "$install_choice" = "y" ] || [ "$install_choice" = "Y" ]; then
            if ! command -v brew &> /dev/null; then
                print_error "Homebrew not found. Please install Homebrew first:"
                echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                exit 1
            fi
            print_status "Installing missing dependencies..."
            brew install php gcc make git 2>/dev/null || {
                print_error "Failed to install dependencies. Please install manually."
                exit 1
            }
            # Update PHP_CMD after installation
            if [ -f "/opt/homebrew/bin/php" ]; then
                PHP_CMD="/opt/homebrew/bin/php"
            elif [ -f "/usr/local/bin/php" ]; then
                PHP_CMD="/usr/local/bin/php"
            else
                PHP_CMD="php"
            fi
        else
            print_error "Please install missing dependencies before continuing."
            exit 1
        fi
    else
        echo "To install missing dependencies on Linux, run:"
        echo "  sudo apt update && sudo apt install -y apache2 php libapache2-mod-php gcc make git"
        echo ""
        read -p "Would you like to install missing dependencies now? (y/n): " install_choice
        if [ "$install_choice" = "y" ] || [ "$install_choice" = "Y" ]; then
            print_status "Installing missing dependencies..."
            sudo apt update && sudo apt install -y apache2 php libapache2-mod-php gcc make git || {
                print_error "Failed to install dependencies. Please install manually."
                exit 1
            }
        else
            print_error "Please install missing dependencies before continuing."
            exit 1
        fi
    fi
    echo ""
fi

# Verify PHP works
if [ -n "$PHP_CMD" ]; then
    if ! $PHP_CMD --version &> /dev/null; then
        print_error "PHP is installed but not working properly."
        exit 1
    fi
fi

print_status "All dependencies are satisfied!"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Compile programs
echo "Step 3: Compiling Vulnerable Programs..."
echo "----------------------------------------"
if [ ! -d "src" ]; then
    print_error "Source directory not found. Are you in the correct directory?"
    exit 1
fi

make clean > /dev/null 2>&1
if make > /dev/null 2>&1; then
    print_status "Compilation successful!"
else
    print_error "Compilation failed! Please check if GCC is installed correctly."
    exit 1
fi

# Set permissions
echo ""
echo "Step 4: Setting Permissions..."
echo "--------------------------------"
chmod +x bin/* 2>/dev/null
chmod +x cgi-bin/*.php 2>/dev/null
chmod +x *.sh 2>/dev/null
print_status "Permissions set"

echo ""
echo "==========================================="
print_status "Setup Complete!"
echo ""
echo "All dependencies checked and satisfied."
echo "Programs compiled successfully."
echo ""
echo "Next steps:"
echo "  1. Run: ./start.sh"
echo "  2. Open: http://localhost:8080"
echo ""
