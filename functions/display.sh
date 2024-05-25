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
    gum style --padding "1 5" --border double --border-foreground 070 "$(gum style --foreground 101 'NOW PLAYING')" "" "$(gum style --foreground 066 "$song_name") by $(gum style --foreground 068 "$artist")" "" "Album: $(gum style --foreground 105 "$album")" "Duration: $(gum style --foreground 080 "$duration")" "Next: $(gum style --foreground 065 "$next_song_name") by $(gum style --foreground 100 "$next_artist")" "Queue: $(gum style --foreground 130 "$queue_count")"
}

display_help() {
    display_logo
    gum style --padding "1 5" --border double --border-foreground 240 "1. Show help (h)" "2. Pause/Play (p)" "3. Replay current song (r)" "4. Add a song to queue (a)" "5. Display Queue (d)" "6. Next Song (n)" "7. Previous Song (b)" "8. Volume up (j)" "9. Volume down (k)" "10. Check current position (c)" "11. Lyrics (l)" "12. Go back (u)" "13. Kill and go back to menu (t)" "14. Silently go back to menu (s)" "15. Quit (q)" "16. Change song directory (x)" "" "NOTE :: Capital letters also work"
    gum style --padding "1 5" --border double --border-foreground 245 "To GO BACK press u or U"
    
}