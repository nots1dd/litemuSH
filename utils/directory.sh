#!/bin/bash

# Function to handle Ctrl+C and exit the script
trap 'echo -e "\n\n${RED}Exiting...${NC}"; exit 1' SIGINT

# Define color variables
RED='\033[0;31m'
NC='\033[0m' # No Color

directory_func() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "$(gum style --foreground 212 'LITEMUS - Light Music Player')" "" "Enter the song directory to play!" "" "Enter $(gum style --foreground 090 '^C (Ctrl+C)') to exit"

    while true; do
        directory=$(gum input --placeholder="Enter your song directory!")

        if [ $? -ne 0 ]; then
            gum spin --title="Exiting Litemus..." -- sleep 0.5
            exit
        fi

        if [ -d "$directory" ]; then
            if gum confirm "Directory '$directory' exists. Are you sure you want to use this directory?"; then
                no=$(find "$directory" -type f -name "*.mp3" | wc -l)
                if [ "$no" -ne 0 ]; then
                    echo "" > "$cache" # ensuring nothing is there
                    echo "$directory" > "$cache"
                    cd "$directory"
                    clear
                    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Hello, there! Welcome to $(gum style --foreground 212 'LITEMUS')"
                    gum spin --spinner dot --title "Launching LITEMUS..." -- sleep 0.5
                    break
                else
                    gum style --foreground 196 "No valid .mp3 files found in '$directory'. Please enter a different directory."
                fi
            else
                gum style --foreground 214 "Please enter a new directory."
            fi
        else
            gum style --foreground 196 "Directory '$directory' does not exist. Please enter a valid directory."
        fi
    done
}

# Function to check and prompt for directory
check_directory() {
    if [ -f "$cache" ] && [ -s "$cache" ]; then
        directory=$(cat "$cache")
        if [ -d "$directory" ] && [ "$(find "$directory" -type f -name "*.mp3" | wc -l)" -gt 0 ]; then
            cd "$directory"
            return
        else
            gum style --foreground 196 "Cached directory '$directory' is invalid or contains no .mp3 files. Please enter a new directory."
        fi
    fi
    directory_func
    
}
