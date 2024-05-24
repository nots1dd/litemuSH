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

src="/home/$USER/misc/litemus" # change this to whatever directory litemus is in

# sources
source $src/utils/modules.sh

clear
check_directory
cd "$directory"

status_line=""
timer_line=""

display_logo() {
    echo -e "    " "${BLUE}${BOLD}LITEMUS - Light Music Player\n"
}

# Song Management
declare -a song_list
declare -a queue
current_index=-1

# Main play function
play() {
    clear
    display_logo

    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); print artist}' | sort -u | gum choose --header "Choose artist" --limit 1 --height 30)
    if [ "$selected_artist" = "user aborted" ]; then
        gum confirm --default "Exit Litemus?" && exit || play
    else
        clear
        display_logo
        gum style --padding "1 5" --border double --border-foreground 212 "You selected artist:  $(gum style --foreground 200 "$selected_artist")"

        # Filter songs by selected artist
        mapfile -t song_list < <(ls *.mp3 | grep "^$selected_artist" | sort)

        # Sort songs by album using ffprobe
        declare -A album_sorted_songs
        for song in "${song_list[@]}"; do
            album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")
            album=${album:-"Unknown Album"}
            album_sorted_songs["$album"]+="$song"$'\n' # TODO: Find a good way to giving new line to every song, right now there is a blank line between every album's songs
        done

        # Convert associative array to a list of songs sorted by album
        sorted_song_list=()
        for album in "${!album_sorted_songs[@]}"; do
            mapfile -t album_songs <<< "${album_sorted_songs[$album]}"
            for song in "${album_songs[@]}"; do
                if [ "$song" != "\n" ]; then
                    sorted_song_list+=("$song")
                fi
            done
        done

        # Present the list of song names to the user for selection
        song_display_list=()
        for song in "${sorted_song_list[@]}"; do
            song_display_list+=("$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')")
        done

        # Store the selected song display name in the variable "selected_song_display"
        selected_song_display=$(printf "%s\n" "${song_display_list[@]}" | gum choose --header "Choose song" --limit 1 --height 30)
        
        if [ "$selected_song_display" = "user aborted" ] || [ -z "$selected_song_display" ]; then
            gum confirm --default "Exit Litemus?" && exit || play
        else
            # Find the full name of the selected song
            selected_song=""
            for song in "${sorted_song_list[@]}"; do
                song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
                if [ "$song_name" = "$selected_song_display" ]; then
                    selected_song="$song"
                    break
                fi
            done

            queue=("$selected_song" "${queue[@]}") # Add to the beginning of the queue
            current_index=0

            # Add the selected song to the played_songs array
            played_songs+=("$selected_song")

            ffplay_song_at_index "$current_index"
        fi
    fi
}




clear
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Hello, there! Welcome to $(gum style --foreground 212 'LITEMUS')"
gum spin --spinner dot --title "Launching LITEMUS..." -- sleep 0.5
load_songs
play

# Variable to track playback status (0 = playing, 1 = paused)
paused=0

# Trap the SIGINT signal (Ctrl+C) to exit the playback
trap exit SIGINT
