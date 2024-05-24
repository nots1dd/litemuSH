# Play the song at the given index
ffplay_song_at_index() {
    local index="$1"
    if [ "$index" -lt 0 ] || [ "$index" -ge "${#queue[@]}" ]; then
        echo -e "${RED}Invalid song index.${NC}"
        return
    fi

    current_index="$index"
    local song="${queue[$current_index]}"
    selected_song="$song"

    clear
    display_logo
    cover_image=$(extract_cover "$song")
    copy_to_tmp "$cover_image"
    cleanup_temp_dir "$(dirname "$cover_image")"

    # Get duration of the selected song
    duration=$(get_duration "$song")

    # Display current song information
    display_song_info_minimal "$song" "$duration"
    time=$(ffprobe -v quiet -print_format json -show_format -show_streams "$song" | jq -r '.format.duration')


    # Play the selected song using ffplay in the background and store the PID
    killall ffplay >/dev/null 2>&1
    
    ffplay -nodisp -autoexit "$song" >/dev/null 2>&1 &
    # playback_time
    ffplay_pid=$!
    keybinds
    wait $ffplay_pid
    # for smooth transistion to the next song
    current_index=$((current_index + 1))
    if [ "$current_index" -lt "${#queue[@]}" ]; then
        ffplay_song_at_index "$current_index"
    else
        gum style --padding "1 5" --border double --border-foreground 212 "End of queue. Returning to song selection."
        play
    fi


}

# Restart the current song
ffrestart_song() {
    if [ -z "$selected_song" ]; then
        echo -e "${RED}No song is currently selected.${NC}"
        return
    fi

    # Restart the selected song using ffplay in the background and store the PID
    killall ffplay >/dev/null 2>&1
    song="${queue[$current_index]}"
    ffplay -nodisp -autoexit "$song" >/dev/null 2>&1 &
    # playback_time
    ffplay_pid=$!
}

