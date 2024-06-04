queue_func() {
    clear
    display_logo
    gum style --padding "$gum_padding" --border double --border-foreground "$gum_border_foreground" "Add Song to Queue"

    song_count=$(ls *.mp3 | wc -l)
    if [ "$song_count" -eq "$dir_song_count" ]; then
        selected_artist=$(cat "$src/.cache/artists.cache" | gum choose --cursor-prefix=1 --header "$gum_select_artist_message" --cursor.foreground "$gum_selected_cursor_foreground" --selected.foreground "$gum_selected_text_foreground" --header.foreground "$gum_header_foreground" --limit 1 --height $gum_height)
    else
        update_artist_cache
    fi
    if [ "$selected_artist" = "" ]; then
        gum confirm --default --selected.foreground "$gum_confirm_selected_text_foreground" --unselected.foreground "$gum_confirm_unselected_text_foreground" --prompt.foreground "$gum_confirm_prompt_foreground" "Exit Litemus?" && exit || queue_func
    else
        clear
        display_logo
        gum style --padding "$gum_padding" --border double --border-foreground "$gum_border_foreground" "You selected artist:  $(gum style --foreground "$gum_artist_foreground" "$selected_artist")"

        # Filter songs by selected artist
        mapfile -t song_list < <(ls *.mp3 | grep "^$selected_artist" | sort)

        # Ensure cache directory exists
        mkdir -p "$cache_dir"
        local cache_file="$cache_dir/${selected_artist// /_}.cache"

        if [ -f "$cache_file" ]; then
            load_sorted_songs_from_cache "$selected_artist"
        else
            sort_songs_by_album "$selected_artist"
            save_sorted_songs_to_cache "$selected_artist"
            gum spin --title="Caching artist..." -- sleep 0.3
        fi

        # Present the list of song names to the user for selection
        selected_song_display=$(printf "%s\n" "${song_display_list[@]}" | gum choose --cursor-prefix=1 --header "$gum_select_song_message" --cursor.foreground "$gum_selected_cursor_foreground" --selected.foreground "$gum_selected_text_foreground" --header.foreground "$gum_header_foreground" --limit 1 --height $gum_height)

        
        if [ "$selected_song_display" = "" ]; then
            gum confirm --default --selected.foreground "$gum_confirm_selected_text_foreground" --unselected.foreground "$gum_confirm_unselected_text_foreground" --prompt.foreground "$gum_confirm_prompt_foreground" "Exit Litemus?" && exit || queue_func
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

            if [ $current_index -lt ${#queue[@]} ]; then
                queue=("${queue[@]:0:$current_index+1}" "$selected_song" "${queue[@]:$current_index+1}")
            else
                queue+=("$selected_song")
            fi
            clear
            load_theme "$theme_dir"
            display_song_info_minimal "${queue[$current_index]}" "$duration"
            status_line="Added song to queue: ${BLUE}"$selected_song"${NC}"
        fi
    fi
}

remove_song_from_queue_func() {
    clear
    display_logo
    gum style --padding "$gum_padding" --border double --border-foreground "$gum_border_foreground" "Remove Song from Queue"

    if [ ${#queue[@]} -eq 0 ]; then
        gum style --padding "$gum_padding" --border double --border-foreground "$gum_border_foreground" "The queue is empty!"
        gum spin --title="Redirecting..." -- sleep 0.3
        return
    fi
    if [ ${#queue[@]} -eq 1 ]; then
        # load_theme "$theme_dir"
        display_song_info_minimal "${queue[$current_index]}" "$duration"
        status_line="Only 1 song in queue!"
        return
    fi


    # Present the list of current songs in the queue for selection
    selected_song_display=$(printf "%s\n" "${queue[@]}" | gum choose --cursor-prefix=1 --header "Select a song to remove:" --cursor.foreground "$gum_selected_cursor_foreground" --selected.foreground "$gum_selected_text_foreground" --header.foreground "$gum_header_foreground" --limit 1 --height $gum_height)
    
    if [ "$selected_song_display" = "" ]; then
        clear
        display_logo
        display_song_info_minimal "${queue[$current_index]}" "$duration"
    else
        # Find and remove the selected song from the queue
        for i in "${!queue[@]}"; do
            if [ "${queue[$i]}" = "$selected_song_display" ]; then
                queue=("${queue[@]:0:$i}" "${queue[@]:$((i + 1))}")
                break
            fi
        done
        clear
        # load_theme "$theme_dir"
        display_song_info_minimal "${queue[$current_index]}" "$duration"
        status_line="Removed song from queue: ${RED}"$selected_song_display"${NC}"
    fi
}


display_queue() {
    clear
    display_logo

    if [ "${#queue[@]}" -eq 0 ]; then
        echo -e "${YELLOW}The queue is currently empty.${NC}"
    else
        echo -e "${GREEN}Current Queue:${NC}"
        
        queue_display=""
        for i in "${!queue[@]}"; do
            # Extract artist and song name
            artist=$(echo "${queue[$i]}" | awk -F ' - ' '{ print $1 }')
            song=$(echo "${queue[$i]}" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')

            display_text="$song by $artist"
            
            if [ "$i" -eq "$current_index" ]; then
                queue_display+=$(gum style --foreground 066 ">> $display_text")
            else
                queue_display+="$display_text"
            fi
            queue_display+="\n"
        done

        # Use gum style to display the entire queue
        gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_now_playing" "$(echo -e "$queue_display")"
        gum style --padding "$gum_padding" --border double --border-foreground "$border_foreground_now_playing" "To GO BACK press "$display_minimal_info""
    fi
}
