#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Define style for the header
HEADER_COLOR='\033[0;32m'
HEADER_BORDER_COLOR='\033[1;32m'
BORDER_CHAR='═'

# Function to print styled header
print_header() {
    local text=" LITEMUS - Light Music Player "
    local title="      LITEMUS Installer"
    local width=${#text}

    echo -e "${HEADER_BORDER_COLOR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${NC}"
    echo -e "${HEADER_BORDER_COLOR}${NC}${HEADER_COLOR}${text}${NC}${HEADER_BORDER_COLOR}${NC}"
    echo -e "${HEADER_BORDER_COLOR}${NC}${HEADER_COLOR}${title}${NC}${HEADER_BORDER_COLOR}${NC}"
    echo -e "${HEADER_BORDER_COLOR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${HEADER_BORDER_COLOR}${NC}"
}

# Function to install dependencies
install_dependencies() {
    echo -e "Installing dependencies..."
    yay -S --noconfirm bc ffmpeg viu grep awk gum jq # will update install script to ask for which package man to go for
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Dependencies installed.${NC}"
    else
        echo -e "${RED}${BOLD}Failed to install dependencies.${NC}"
        exit 1
    fi
}

# Function to create alias for the music player
create_alias() {
    local shell_name="${SHELL##*/}"

    if [ "$shell_name" == "bash" ]; then
        echo "alias lmus='$INSTALL_DIR/$SCRIPT_NAME'" >> "$HOME/.bashrc"
        echo -e "${GREEN}Alias 'lmus' created for bash users. You can now use 'lmus' to run the music player.${NC}"
    elif [ "$shell_name" == "zsh" ]; then
        echo "alias lmus='$INSTALL_DIR/$SCRIPT_NAME'" >> "$HOME/.zshrc"
        echo -e "${GREEN}Alias 'lmus' created for zsh users. You can now use 'lmus' to run the music player.${NC}"
    else
        echo -e "${RED}Unsupported shell detected. Please manually add the alias for your shell.${NC}"
    fi
}

# Function to check if the password was given
check_password() {
    if ! sudo -v >/dev/null 2>&1; then
        echo -e "${RED}${BOLD}Failed to obtain sudo privileges. Please run the script with the correct password.${NC}"
        exit 1
    fi
}

# Print header
print_header

# Check if the password was given
check_password

# Install dependencies
install_dependencies

# Create alias for the music player
create_alias

echo -e "${GREEN}${BOLD}Installation complete.${NC}"
