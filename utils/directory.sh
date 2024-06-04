#!/bin/bash

# Function to handle Ctrl+C and exit the script
trap 'echo -e "\n\n${RED}Exiting...${NC}"; exit 1' SIGINT

# Define color variables
RED='\033[0;31m'
NC='\033[0m' # No Color

directory_func() {
    gum style --border normal --margin "1" --padding "$gum_padding" --border-foreground $gum_border_foreground "$(gum style --foreground 212 'LITEMUS - Light Music Player')" "" "Enter the song directory to play!" "" "Enter $(gum style --foreground 067 '^C (Ctrl+C)') to exit" "NOTE :: /home/$USER/ need not be added"

    while true; do
        directory=$(gum input --placeholder="Enter your song directory!")

        if [ $? -ne 0 ]; then
            gum spin --title="Exiting Litemus..." -- sleep 0.5
            exit
        fi

        if [ -d "/home/$USER/$directory" ]; then
            directory="/home/$USER/$directory"
        fi
        if [ -d "$directory" ]; then
            if gum confirm "Directory '$directory' exists. Are you sure you want to use this directory?"; then
                no=$(find "$directory" -type f -name "*.mp3" | wc -l)
                if [ "$no" -ne 0 ]; then
                    echo "" > "$dir_cache" # ensuring nothing is there
                    echo "$directory" > "$dir_cache"
                    cd "$directory"
                    clear
                    gum style --border normal --margin "1" --padding "$gum_padding" --border-foreground "$gum_border_foreground" "Hello, there! Welcome to $(gum style --foreground "$gum_selected_text_foreground" 'LITEMUS')"
                    gum spin --spinner dot --title "Launching LITEMUS..." -- sleep 0.2
                    break
                else
                    gum style --foreground "$gum_colors_error" "No valid .mp3 files found in '$directory'. Please enter a different directory."
                fi
            else
                gum style --foreground "$gum_header_foreground" "Please enter a new directory."
            fi
        else
            gum style --foreground "$gum_colors_error" "Directory '$directory' does not exist. Please enter a valid directory."
        fi
    done
}

# Function to check and prompt for directory
check_directory() {
    if [ -f "$dir_cache" ] && [ -s "$dir_cache" ]; then
        directory=$(cat "$dir_cache")
        if [ -d "$directory" ] && [ "$(find "$directory" -type f -name "*.mp3" | wc -l)" -gt 0 ]; then
            cd "$directory"
            
            # Check if all .mp3 files follow the 'Artist - Song.mp3' format
            invalid_files=$(find . -maxdepth 1 -type f -name "*.mp3" ! -regex "\./[^-]+ - [^/]+\.mp3" | wc -l)
            if [ "$invalid_files" -gt 0 ]; then
                gum style --foreground 196 "Some files do not follow the 'Artist - Song.mp3' format. Please correct them and try again."
                directory_func
                return
            fi
            
            # Store artist names in a cache file
            artist_cache="$src/.cache/artists.cache"
            count_cache="$src/.cache/dircount.cache"
            mkdir -p "$cache_dir"
            find . -maxdepth 1 -type f -name "*.mp3" | awk -F ' - ' '{ print substr($1, 3) }' | sort -u > "$artist_cache"
            dir_song_count=$(ls *.mp3 | wc -l)
            echo "$dir_song_count" > "$count_cache"
            
            return
        else
            gum style --foreground 196 "Cached directory '$directory' is invalid or contains no .mp3 files. Please enter a new directory."
        fi
    fi
    directory_func
}

update_artist_cache() {
    artist_cache="$src/.cache/artists.cache"
    count_cache="$src/.cache/dircount.cache"
    mkdir -p "$cache_dir"
    find . -maxdepth 1 -type f -name "*.mp3" | awk -F ' - ' '{ print substr($1, 3) }' | sort -u > "$artist_cache"
    dir_song_count=$(ls *.mp3 | wc -l)
    echo "$dir_song_count" > "$count_cache"
    play
}