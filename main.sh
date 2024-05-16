#!/bin/bash

# LITEMUS (Light music player)

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PINK='\033[1;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# written by nots1dd
# NOTE :: This script uses ffplay to play audio NOT PLAYERCTL
# HENCE, it will NOT work well with your current configs that use playerctl and such

# DEPENDENCIES
# 1. ffmpeg and its family tree (ffprobe, ffplay)
# 2. smenu
# 3. bc (basic calculator) [AUR PACKAGE]
# 4. viu (terminal image emulator) [AUR PACKAGE]
# 5. grep, awk, trap (very important basic unix tools)

clear
cd ~/Downloads/Songs

status_line=""
# Function to extract and display thumbnail
extract_cover() {
    input_file="$1"
    temp_dir=$(mktemp -d)
    ffmpeg -y -i "$input_file" -an -vcodec copy "$temp_dir/cover_new.png" >/dev/null 2>&1
    echo "$temp_dir/cover_new.png"
}

cover_success() {
    echo "Cover image extracted!"
}

copy_to_tmp() {
    cp "$1" ~/newtmp.png
    # echo "Copied!"
}

cleanup_temp_dir() {
    rm -rf "$1"
    # echo "tmp image removed!"
}

# Function to pause playback
# Function to toggle playback status (pause/play)
toggle_playback() {
    if [[ $paused -eq 0 ]]; then
        # If currently playing, pause playback
        if kill -STOP "$ffplay_pid" >/dev/null 2>&1; then
            status_line="${YELLOW}Status: Paused${NC}"
            return 0
        else
            return 1
        fi
    else
        # If currently paused, resume playback
        if kill -CONT "$ffplay_pid" >/dev/null 2>&1; then
            status_line="${GREEN}Status: Playing${NC}"
            return 0
        else
            return 1
        fi
    fi
}




increase_volume() {
    amixer -q sset Master 2%+
}

decrease_volume() {
    amixer -q sset Master 2%-
}

display_logo() {
    echo -e "    " "${BLUE}${BOLD}LITEMUS - Light Music Player\n"
}

# Function to display current song information
display_song_info() {
    local song="$1"
    local duration="$2"

    # Extract song name and artist from the file name
    song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
    artist=$(echo "$song" | awk -F ' - ' '{ print $1 }')

    status="$3"

    clear

    # Display the song information
    display_logo
    viu --width 35 --height 15 ~/newtmp.png
    echo -e  "\n${GREEN}            NOW PLAYING\n" "\n${BLUE}$song_name${NC} by ${YELLOW}$artist${NC} (${YELLOW}$duration${NC})\n"

}


# Function to get duration of a song (ffprobe gets results in seconds ONLY that are floating of 0.6f degree ex. 255.000123)
get_duration() {
    local song="$1"
    time=$(ffprobe -v quiet -print_format json -show_format -show_streams "$song" | jq -r '.format.duration')
    # Convert duration to floating-point number
    duration_seconds=$(echo "$time" | bc -l)
    # Round duration_seconds to the nearest integer
    duration_seconds=$(printf "%.0f" "$duration_seconds") # (not doing this step leads to some weird results on my local machine, modify this function as you need)
    # Calculate minutes and seconds
    minutes=$((duration_seconds / 60))
    seconds=$((duration_seconds % 60))
    printf "%02d:%02d\n" "$minutes" "$seconds"
}

get_lyrics() {
    local song="$1"
    local lyrics=$(ffprobe -v quiet -print_format json -show_entries format_tags=lyrics-XXX -of default=nw=1:nk=1 "$song" 2>/dev/null)
    if [ "$lyrics" = "" ]; then
        clear
        echo -e "\nLyrics not available for this song.\n" "\nTo ${GREEN}GO BACK${NC} press ${YELLOW}u/U"
    else
        clear
        echo -e "\n$1\n" "\n${PINK}$lyrics\n"
    fi
}




show_smenu() {
    smenu -Q -c -n15 -W $'\n' -q -2 "$@" -m "Select Song"
}

display_help() {
    echo -e "${BOLD}LITEMUS HELP" "\n${NC}->Pause/Play (p) ${NC}" "\n${NC}->Volume+ (j)${NC} ${NC}Volume- (k)${NC}" "\n${NC}->Check current position (c)${NC}" "\n${NC}->Lyrics (l) ${NC}Go back (u)" "\n${NC}->Kill and go back to menu (t)${NC} ${NC}Silently go back to menu (s)${NC}" "\n${NC}->Quit (q)\n"
}

# Store the selected artist in the variable "selected_artist"
play() {
    display_logo
    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); gsub(/'\''/, "_", artist); print artist }' | sort -u | smenu -Q -c -q -n30 -W $'\n' -m "Select Artist")
    if [ "$selected_artist" = "" ]; then
        exit
    else
    clear
    display_logo
    echo -e "${NC}You selected artist:${GREEN} $selected_artist\n"

    # Store the selected song in the variable "selected_song"
    selected_song=$(ls *.mp3 | grep "^$selected_artist" | show_smenu "^$selected_artist")
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

    display_help

    # Play the selected song using ffplay in the background and store the PID
    killall ffplay >/dev/null 2>&1
    ffplay -nodisp -autoexit "$selected_song" >/dev/null 2>&1 &
    ffplay_pid=$!
    fi
    fi
}
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
            display_help
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
