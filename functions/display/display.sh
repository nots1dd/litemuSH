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

    cache_misc_dir="$src/.cache/misc"

    # Create the cache directory if it doesn't exist
    mkdir -p "$cache_misc_dir"

    # Create a unique cache file name based on the song path
    cache_file="$cache_misc_dir/songinfo.cache"
    rm -rf "$cache_file"

    # Function to retrieve and cache song metadata
    cache_song_metadata() {
        song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//' | tr -d '\n')
        artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$song")
        album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")
        year=$(ffprobe -v quiet -print_format json -show_entries format_tags=date -of default=nw=1:nk=1 "$song" | awk -F '-' '{print $1}')

        # Write metadata to cache file
        echo "$song_name" > "$cache_file"
        echo "$artist" >> "$cache_file"
        echo "$album" >> "$cache_file"
        echo "$year" >> "$cache_file"
        echo "$duration" >> "$cache_file"
    }

    # Check if metadata is already cached
    if [ -f "$cache_file" ]; then
        song_name=$(cat "$cache_file" | head -n 1)
        artist=$(cat "$cache_file" | head -n 2)
        album=$(cat "$cache_file" | head -n 3)
        year=$(cat "$cache_file" | head -n 4)
        duration=$(cat "$cache_file" | head -n 5)
    else
        cache_song_metadata
    fi

    clear

    # Find the next valid song
    next_index=$((current_index + 1))
    next_song="${queue[$next_index]}"

    if [ "$next_index" -lt "${#queue[@]}" ]; then
        next_song_name=$(echo "$next_song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//' | tr -d '\n')
        next_artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$next_song")
    else
        next_song_name="N/A"
        next_artist="N/A"
    fi

    queue_count=$(( ${#queue[@]} - current_index - 1 ))
    total_queue_count=$((${#queue[@]} - 1))
    if [ "$show_time_in_queue" = "false" ]; then
        queue_time=""
    elif [ "$show_time_in_queue" = "true" ]; then
        queue_time="Play time: $(gum style --foreground "$foreground_queue_time" "$(calculate_time_left_in_queue)")"
    else
        queue_time=""
    fi

    display_logo
    viu --width "$image_width" --height "$image_height" "$image_dir"
    gum style --padding "$gum_padding" --border thick --border-foreground "$border_foreground_now_playing" "" "$(gum style --foreground "$foreground_now_playing" "$now_playing_message")" "" "$(gum style --foreground "$foreground_song_name" "$song_name") by $(gum style --foreground "$foreground_artist" "$artist")" "" "Album: $(gum style --foreground "$foreground_album" "$album")" "Year: $(gum style --foreground "$foreground_year" "$year")" "Duration: $(gum style --foreground "$foreground_duration" "$duration")" "Next: $(gum style --foreground "$foreground_next_song_name" "$next_song_name") by $(gum style --foreground "$foreground_next_artist" "$next_artist")" "In Queue: $(gum style --foreground "$foreground_queue_count" "$queue_count") of $(gum style --foreground "$foreground_total_queue_count" "$total_queue_count")" "$queue_time"
}

decor() {
    gum style --foreground "$foreground_bold" --bold "$1"
}

display_help() {
    clear
    display_logo
    help_text="
1. Show help  '($display_help)'
2. Pause/Play  '($toggle_pause)'
3. Replay current song  '($restart_song)'
4. Add a song to queue '($add_song_to_queue)'
5. Display Queue  '($display_queue)'
6. Next Song  '($play_next_song)'
7. Previous Song  '($play_previous_song)'
8. Volume up  '($increase_volume)'
9. Volume down  '($decrease_volume)'
10. Check current position  '($check_current_position)'
11. Lyrics  '($display_lyrics)'
12. Go back  '($display_minimal_info)'
13. Kill and go back to menu  '($return_to_song_selection)'
14. Silently go back to menu  '($go_back_silently)'
15. Quit  '($quit)'
16. Change song directory  '($change_directory)'
17. Reload theme '($reload_theme)'

$(decor "NOTE :: Capital letters also work")
"
    gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_help" "$help_text"
    gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_help" "To GO BACK press '$(echo $display_minimal_info)'"
}