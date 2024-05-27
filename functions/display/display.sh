 # THIS FUNCTION IS O(n) so as the number of songs increases, the performance of this function decreases.
 # Hence, i have tried to increase efficiency of the function by creating cache, but initially if you are loading 15+ songs, you will notice a delay of 2-3 seconds.
 # The current function now ONLY performs that loop when the queue count changes (so whenever you add songs to queue), when the current_index changes (going prev/next song), or if the cache files are not found
 # The above fix makes sure that bloated and pointless tasks are not performed, which also technically reduces the time delay of this function
 # Aside from this, I plan on customizing the display screen a bit more so in the future there will be an option to NOT display this, which will not lead to any inefficiencies or time delay
calculate_time_left_in_queue() {
    time_cache_file="$src/.cache/misc/time.cache"
    cache_index_file="$src/.cache/misc/index.cache"
    queue_count_file="$src/.cache/misc/queue_count.cache"

    # Ensure the cache directory exists
    mkdir -p "$(dirname "$time_cache_file")" > /dev/null 2>&1
    mkdir -p "$(dirname "$cache_index_file")" > /dev/null 2>&1
    mkdir -p "$(dirname "$queue_count_file")" > /dev/null 2>&1

    total_time_left=0
    current_queue_count=${#queue[@]}
    update_cache=false

    # Read cache files if they exist
    if [[ -f "$time_cache_file" && -f "$cache_index_file" && -f "$queue_count_file" ]]; then
        cached_index=$(cat "$cache_index_file")
        cached_queue_count=$(cat "$queue_count_file")
        cached_total_time_left=$(cat "$time_cache_file")

        # Determine if cache should be updated
        if [[ "$cached_queue_count" -ne "$current_queue_count" ]]; then
            update_cache=true
        elif [[ "$cached_index" -lt "$current_index" ]]; then
            # Next song played
            prev_song_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${queue[$cached_index]}")
            total_time_left=$(awk "BEGIN {print $cached_total_time_left - $prev_song_duration}")
            echo "$total_time_left" > "$time_cache_file"
            echo "$current_index" > "$cache_index_file"
            echo "$current_queue_count" > "$queue_count_file"
        elif [[ "$cached_index" -gt "$current_index" ]]; then
            # Previous song played
            current_song_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${queue[$current_index]}")
            total_time_left=$(awk "BEGIN {print $cached_total_time_left + $current_song_duration}")
            echo "$total_time_left" > "$time_cache_file"
            echo "$current_index" > "$cache_index_file"
            echo "$current_queue_count" > "$queue_count_file"
        else
            total_time_left=$cached_total_time_left
        fi
    else
        update_cache=true
    fi

    # Update cache if necessary
    if [[ "$update_cache" == true ]]; then
        for ((i = current_index; i < ${#queue[@]}; i++)); do
            song="${queue[$i]}"
            song_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$song")

            if [[ "$song_duration" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                total_time_left=$(awk "BEGIN {print $total_time_left + $song_duration}")
            fi
        done

        # Update the cache files
        echo "$total_time_left" > "$time_cache_file"
        echo "$current_index" > "$cache_index_file"
        echo "$current_queue_count" > "$queue_count_file"
    fi

    # Convert total_time_left to minutes and seconds
    minutes=$(awk "BEGIN {print int($total_time_left / 60)}")
    seconds=$(awk "BEGIN {print int($total_time_left % 60)}")

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
    total_queue_count=$((${#queue[@]} - 1))
    queue_time=$(calculate_time_left_in_queue)

    display_logo
    viu --width 24 --height 10 "$image_dir"
    gum style --padding "1 5" --border thick --border-foreground "$border_foreground_now_playing" "$(gum style --foreground "$foreground_now_playing" "$now_playing_message")" "" "$(gum style --foreground "$foreground_song_name" "$song_name") by $(gum style --foreground "$foreground_artist" "$artist")" "" "Album: $(gum style --foreground "$foreground_album" "$album")" "Duration: $(gum style --foreground "$foreground_duration" "$duration")" "Next: $(gum style --foreground "$foreground_next_song_name" "$next_song_name") by $(gum style --foreground "$foreground_next_artist" "$next_artist")" "In Queue: $(gum style --foreground "$foreground_queue_count" "$queue_count") of $(gum style --foreground "$foreground_total_queue_count" "$total_queue_count")" "Play time: $(gum style --foreground "$foreground_queue_time" "$queue_time")"
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