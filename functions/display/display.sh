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
    local status="$3"

    song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//' | tr -d '\n')
    artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$song")
    album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")

    clear

    if [ "$current_index" -lt "$((${#queue[@]} - 1))" ]; then
        next_song="${queue[$((current_index + 1))]}"
        next_song_name=$(echo "$next_song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//' | tr -d '\n')
        next_artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$next_song")
    else
        next_song_name="N/A"
        next_artist="N/A"
    fi

    queue_count=$(( ${#queue[@]} - current_index - 1 ))
    queue_time=$(calculate_time_left_in_queue)

    display_logo
    viu --width 24 --height 10 ~/newtmp.png
    gum style --padding "1 5" --border thick --border-foreground "$border_foreground_now_playing" "$(gum style --foreground "$foreground_now_playing" "$now_playing_message")" "" "$(gum style --foreground "$foreground_song_name" "$song_name") by $(gum style --foreground "$foreground_artist" "$artist")" "" "Album: $(gum style --foreground "$foreground_album" "$album")" "Duration: $(gum style --foreground "$foreground_duration" "$duration")" "Next: $(gum style --foreground "$foreground_next_song_name" "$next_song_name") by $(gum style --foreground "$foreground_next_artist" "$next_artist")" "Queue: $(gum style --foreground "$foreground_queue_count" "$queue_count")" "Play time: $(gum style --foreground "$foreground_queue_time" "$queue_time")"
}

decor() {
    gum style --foreground "$foreground_bold" --bold "$1"
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

$(decor "$help_note_message")
"
    gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_help" "$help_text"
    gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_help" "To GO BACK press $(decor 'u') or $(decor 'U')"
}