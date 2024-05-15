#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'

REPO_URL="https://github.com/nots1dd/litemus"
INSTALL_DIR="$HOME/litemus"
SCRIPT_NAME="main.sh"

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    sudo pacman -S --noconfirm bc ffmpeg viu grep awk
    echo "${GREEN}${BOLD}Dependencies installed."
    echo -e "${YELLOW}In order to install smenu, you need to use yay or build from source.\nNote: Without this the script will NOT run!\n"
}

# Function to create alias for the music player
create_alias() {
    local shell_name="${SHELL##*/}"

    if [ "$shell_name" == "bash" ]; then
        echo "${YELLOW}alias lmus='$INSTALL_DIR/$SCRIPT_NAME'" >> "$HOME/.bashrc"
        echo -e "${GREEN}Alias 'lmus' created for bash users. You can now use 'lmus' to run the music player."
    elif [ "$shell_name" == "zsh" ]; then
        echo "${YELLOW}alias lmus='$INSTALL_DIR/$SCRIPT_NAME'" >> "$HOME/.zshrc"
        echo "${GREEN}Alias 'lmus' created for zsh users. You can now use 'lmus' to run the music player."
    else
        echo "${RED}Unsupported shell detected. Please manually add the alias for your shell."
    fi
}

# # Check if the installation directory exists
# if [ ! -d "$INSTALL_DIR" ]; then
#     echo "Creating installation directory..."
#     mkdir -p "$INSTALL_DIR"
# fi

# Check if the download was successful
if [ $? -eq 0 ]; then
    # Make the script executable

    # Install dependencies
    install_dependencies

    # Create alias for the music player
    create_alias
else
    echo "${RED}${BOLD}Failed to download the script."
    exit 1
fi

echo -e "${GREEN}${BOLD}Installation complete."
