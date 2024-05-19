#!/bin/bash

# LITEMUS (Light music player)

# written by nots1dd
# NOTE :: This script uses ffplay to play audio NOT PLAYERCTL
# HENCE, it will NOT work well with your current configs that use playerctl and such

# DEPENDENCIES
# 1. ffmpeg and its family tree (ffprobe, ffplay)
# 2. gum [AUR PACKAGE]
# 3. bc (basic calculator) [AUR PACKAGE]
# 4. viu (terminal image emulator) [AUR PACKAGE]
# 5. grep, awk, trap (very important basic unix tools)

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PINK='\033[1;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# sources
source /home/s1dd/misc/litemus/lyrics/lyrics.sh
source /home/s1dd/misc/litemus/utils/directory.sh
source /home/s1dd/misc/litemus/functions/extract_cover.sh
source /home/s1dd/misc/litemus/functions/toggle_playback.sh
source /home/s1dd/misc/litemus/functions/volume_ctrl.sh
source /home/s1dd/misc/litemus/functions/display.sh
source /home/s1dd/misc/litemus/functions/duration.sh
source /home/s1dd/misc/litemus/functions/get_lyrics.sh

clear
check_directory
cd $directory

status_line="" 

display_logo() {
    echo -e "    " "${BLUE}${BOLD}LITEMUS - Light Music Player\n"
}

# Store the selected artist in the variable "selected_artist"
play() {
    clear
    display_logo
    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); print artist}' | sort -u | gum choose --header "Choose artist" --limit 1 --height 30)
    if [ "$selected_artist" = "" ]; then
        exit
    else
    clear
    display_logo
    gum style --padding "1 5" --border double --border-foreground 212 "You selected artist:  $(gum style --foreground 200 "$selected_artist")"

    # Store the selected song in the variable "selected_song"
    selected_song=$(ls *.mp3 | grep "^$selected_artist" | gum choose --header "Choose song" --limit 1 --height 30)
    if [ "$selected_song" = "" ]; then
        exit
    else

    # Clear the screen
    clear
    display_logo
    # Display the thumbnail of the selected song
    cover_image=$(extract_cover "/home/s1dd/Downloads/Songs/$selected_song")
    copy_to_tmp "$cover_image"
    cleanup_temp_dir "$(dirname "$cover_image")"
    # Get duration of the selected song
    duration=$(get_duration "$selected_song")

    # Display current song information
    display_song_info "$selected_song" "$duration"
    # display_help

    # Play the selected song using ffplay in the background and store the PID
    killall ffplay >/dev/null 2>&1
    ffplay -nodisp -autoexit "$selected_song" >/dev/null 2>&1 &
    ffplay_pid=$!
    fi
    fi
}
clear
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Hello, there! Welcome to $(gum style --foreground 212 'LITEMUS')"
gum spin --spinner dot --title "Launching LITEMUS..." -- sleep 1
play

# Variable to track playback status (0 = playing, 1 = paused)
paused=0

# Trap the SIGINT signal (Ctrl+C) to exit the playback
trap exit SIGINT

# Loop to continuously handle user input
while true; do
    read -n 1 -s key
    case $key in
        p|P)
            toggle_playback
            if [[ $paused -eq 0 ]]; then
                paused=1
            else
                paused=0
            fi
            ;;
        t|T)
            # Return to song selection menu
            kill "$ffplay_pid" >/dev/null 2>&1
            clear
            play
            ;;
        s|S)
            # dont kill just play in bg
            echo "REDIRECTING..."
            clear
            play
            ;;
        q|Q)
            kill "$ffplay_pid" >/dev/null 2>&1
            echo -e "\n${RED}Exiting...${NC}"
            exit
            ;;
        c|C)
            # Check current position
            if [ -n "$ffplay_pid" ]; then
                current_position=$(ps -o etime= -p "$ffplay_pid")
                status_line="Current position: ${BLUE}$current_position${NC}"
            else
                status_line="${RED}No track is currently playing.${NC}"
            fi
            ;;
        l|L)
            # Extract and display lyrics
            clear
            get_lyrics "$selected_song"
            ;;
        u|U)
            clear
            killall ffprobe >/dev/null 2>&1 # just checking something
            display_song_info "$selected_song" "$duration"
            # display_help
            ;;
        j|J)
            increase_volume
            ;;
        k|K)
            decrease_volume
            ;;
        *)
            continue
            ;;
    esac
    echo -ne "\r\033[K$status_line"
done
