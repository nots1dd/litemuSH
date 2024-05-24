display_song_info_minimal() {
    local song="$1"
    local duration="$2"

    # Extract song name and artist from the file name
    song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
    artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$song")
    album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")

    status="$3"

    clear

    # Get the next song in the queue, if any
    if [ "$current_index" -lt "$((${#queue[@]} - 1))" ]; then
        next_song="${queue[$((current_index + 1))]}"
        next_song_name=$(echo "$next_song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
        next_artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$next_song")
    else
        next_song_name="N/A"
        next_artist="N/A"
    fi

    queue_count=$(( ${#queue[@]} - 1 ))

    # Display the song information
    display_logo
    viu --width 24 --height 10 ~/newtmp.png
    gum style --padding "1 5" --border double --border-foreground 255 "$(gum style --foreground 101 'NOW PLAYING')" "" "$(gum style --foreground 180 "$song_name") by $(gum style --foreground 200 "$artist")" "Album: $(gum style --foreground 105 "$album")" "Duration: $(gum style --foreground 066 "$duration")" "Next: $(gum style --foreground 065 "$next_song_name") by $(gum style --foreground 100 "$next_artist")" "Queue: $(gum style --foreground 130 "$queue_count")"
}

display_help() {
    display_logo
    gum style --padding "1 5" --border double --border-foreground 240 "Show help (h)" "Pause/Play (p)" "Replay current song (r)" "Add a song to queue (a)" "Display Queue (d)" "Next Song (n)" "Previous Song (b)" "Volume up (j)" "Volume down (k)" "Check current position (c)" "Display current queue (d)" "Lyrics (l)" "Go back (u)" "Kill and go back to menu (t)" "Silently go back to menu (s)" "Quit (q)" "" "NOTE :: Capital letters also work"
    gum style --padding "1 5" --border double --border-foreground 245 "To GO BACK press u or U"
    
}