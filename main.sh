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

        # Store the selected song in the variable "selected_song"
        selected_song=$(printf "%s\n" "${song_list[@]}" | gum choose --header "Choose song" --limit 1 --height 30)
        if [ "$selected_song" = "user aborted" ]; then
            gum confirm --default "Exit Litemus?" && exit || play
        else
            queue+=("$selected_song")
            current_index=${#queue[@]}
            ffplay_song_at_index "$((current_index - 1))"
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

# Loop to continuously handle user input
while true; do
    read -n 1 -s key
    case $key in
        p|P)
            toggle_ffplayback
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
            # go back silently
            clear
            play
            ;;
        # o|O)
        #     # just play the next index
        #     play_next
        #     ;;
        # i|I)
        #     # play the previous index
        #     play_previous
        #     ;;
        n|N)
            # Play next song in queue
            ffplay_next_in_queue
            ;;
        b|B)
            # play previous song in queue
            ffplay_prev_in_queue
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
                status_line="Playback:${BLUE}$current_position${NC}/$duration"
            else
                status_line="${RED}No track is currently playing.${NC}"
            fi
            ;;
        l|L)
            # Extract and display lyrics
            status_line=""
            sleep 0.5
            get_lyrics "${queue[$current_index]}"
            ;;
        u|U)
            clear
            display_song_info_minimal "${queue[$current_index]}" "$duration"
            ;;
        h|H)
            clear
            display_help
            ;;
        j|J)
            increase_volume
            ;;
        k|K)
            decrease_volume
            ;;
        a|A)
            # Add song to queue
            clear
            queue_func
            ;;
        d|D)
            # display the queue
            clear
            display_queue
            ;;
        # f|F)
        #     forward_song_5_seconds
        #     ;;
        r|R)
            ffrestart_song
            ;;
            
        *)
            continue
            ;;
    esac
    echo -ne "\r\033[K$status_line"
done
