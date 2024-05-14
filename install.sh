#!/bin/bash

REPO_URL="https://github.com/nots1dd/litemus"

# Define the path where the script will be installed
INSTALL_DIR="~/litemus"

# Define the name of the script file
SCRIPT_NAME="install.sh"

# Check if the download was successful
if [ $? -eq 0 ]; then

    # Make the script executable
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

    # Check the user's shell and create the appropriate alias
    if [ "${SHELL##*/}" == "bash" ]; then
        # For bash users
        echo "alias lmus=$INSTALL_DIR/main.sh" >> ~/.bashrc
        echo "Alias 'lmus' created for bash users. You can now use 'lmus' to run the music player."
    elif [ "${SHELL##*/}" == "zsh" ]; then
        # For zsh users
        echo "alias lmus=$INSTALL_DIR/main.sh" >> ~/.zshrc
        echo "Alias 'lmus' created for zsh users. You can now use 'lmus' to run the music player."
    else
        echo "Unsupported shell detected. Please manually add the alias for your shell."
    fi

else
    echo "Failed to download the script."
    exit 1
fi
