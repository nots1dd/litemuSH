calculate_time_left_in_queue() {
    total_time_left=0

    for ((i = current_index; i < ${#queue[@]}; i++)); do
        song="${queue[$i]}"
        song_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$song")

        if [[ "$song_duration" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            total_time_left=$(echo "$total_time_left + $song_duration" | bc)
        fi
    done

    # Convert total_time_left to minutes and seconds
    minutes=$(echo "$total_time_left / 60" | bc)
    seconds=$(echo "($total_time_left % 60) / 1" | bc)

    echo "${minutes}m ${seconds}s"
}


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

    queue_count=$(( ${#queue[@]} - current_index - 1 ))
    queue_time=$(calculate_time_left_in_queue)

    # Display the song information
    display_logo
    viu --width 24 --height 10 ~/newtmp.png
    gum style --padding "1 5" --border thick --border-foreground 070 "$(gum style --foreground 101 'NOW PLAYING')" "" "$(gum style --foreground 066 "$song_name") by $(gum style --foreground 068 "$artist")" "" "Album: $(gum style --foreground 105 "$album")" "Duration: $(gum style --foreground 080 "$duration")" "Next: $(gum style --foreground 065 "$next_song_name") by $(gum style --foreground 100 "$next_artist")" "Queue: $(gum style --foreground 130 "$queue_count")" "Play time: $(gum style --foreground 135 "$queue_time")"
}

decor() {
    gum style --foreground 100 --bold "$1"
}

display_help() {
    clear
    display_logo
    help_text="
1. Show help $(decor '(h)')
2. Pause/Play $(decor '(p)')
3. Replay current song $(decor '(r)')
4. Add a song to queue $(decor '(a)')
5. Display Queue $(decor '(d)')
6. Next Song $(decor '(n)')
7. Previous Song $(decor '(b)')
8. Volume up $(decor '(j)')
9. Volume down $(decor '(k)')
10. Check current position $(decor '(c)')
11. Lyrics $(decor '(l)')
12. Go back $(decor '(u)')
13. Kill and go back to menu $(decor '(t)')
14. Silently go back to menu $(decor '(s)')
15. Quit $(decor '(q)')
16. Change song directory $(decor '(x)')

NOTE :: Capital letters also work
"
    gum style --padding "1 5" --border double --border-foreground 240 "$help_text"
    gum style --padding "1 5" --border double --border-foreground 245 "To GO BACK press $(decor 'u') or $(decor 'U')"
}