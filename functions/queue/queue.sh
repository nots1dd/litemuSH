queue_func() {
    clear
    display_logo
    gum style --padding "1 3" --border double --border-foreground 240 "Add Song to Queue"

    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); print artist}' | sort -u | gum choose --header "Choose artist" --limit 1 --height 30)
    if [ "$selected_artist" = "user aborted" ]; then
        gum confirm --default "Exit Litemus?" && exit || play
    else
        clear
        display_logo
        gum style --padding "1 5" --border double --border-foreground 212 "You selected artist:  $(gum style --foreground 200 "$selected_artist")"

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
        selected_song_display=$(printf "%s\n" "${song_display_list[@]}" | gum choose --header "Choose song" --limit 1 --height 30)

        
        if [ "$selected_song_display" = "user aborted" ]; then
            gum confirm --default "Exit Litemus?" && exit || queue_func
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

            queue+=("$selected_song")
            clear
            display_logo
            gum style --padding "1 5" --border double --border-foreground 212 "SUCCESS!" "Added to queue:  $(gum style --foreground 200 "$selected_song")"
            gum spin --title="Redirecting..." -- sleep 0.2
            clear
            display_song_info_minimal "${queue[$current_index]}" "$duration"
        fi
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
            if [ "$i" -eq "$current_index" ]; then
                queue_display+=$(gum style --foreground 066 ">> ${queue[$i]}")
            else
                queue_display+="${queue[$i]}"
            fi
            queue_display+="\n"
        done

        # Use gum style to display the entire queue
        gum style --padding "1 5" --border double --border-foreground 212 "$(echo -e "$queue_display")"
        gum style --padding "1 5" --border double --border-foreground 245 "To GO BACK press u or U"
    fi
}
