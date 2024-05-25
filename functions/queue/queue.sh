queue_func() {
    display_logo
    gum style --padding "1 1" --border-foreground 240 "Add Song to Queue"
    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); print artist}' | sort -u | gum choose --header "Choose artist" --limit 1 --height 30)
    if [ "$selected_artist" = "user aborted" ]; then
        clear
        display_song_info_minimal "${queue[$current_index]}" "$duration"
    else
        clear
        display_logo
        gum style --padding "1 5" --border double --border-foreground 212 "You selected artist:  $(gum style --foreground 200 "$selected_artist")"

        # Filter songs by selected artist
        mapfile -t song_list < <(ls *.mp3 | grep "^$selected_artist" | sort)

        # Sort songs by album using ffprobe
        declare -A album_sorted_songs
        for song in "${song_list[@]}"; do
            album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")
            album=${album:-"Unknown Album"}
            album_sorted_songs["$album"]+="$song"$'\n' # TODO: Find a good way to giving new line to every song, right now there is a blank line between every album's songs
        done

        # Convert associative array to a list of songs sorted by album
        sorted_song_list=()
        for album in "${!album_sorted_songs[@]}"; do
            mapfile -t album_songs <<< "${album_sorted_songs[$album]}"
            for song in "${album_songs[@]}"; do
                if [ "$song" != "\n" ]; then
                    sorted_song_list+=("$song")
                fi
            done
        done

        # Present the list of song names to the user for selection
        song_display_list=()
        for song in "${sorted_song_list[@]}"; do
            song_display_list+=("$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')")
        done

        # Store the selected song display name in the variable "selected_song_display"
        selected_song_display=$(printf "%s\n" "${song_display_list[@]}" | gum choose --header "Choose song" --limit 1 --height 30)
        
        if [ "$selected_song_display" = "user aborted" ]; then
            gum confirm --default "Exit Litemus?" && exit || play
        else
            # Find the full name of the selected song
            selected_song=""
            for song in "${song_list[@]}"; do
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
            gum spin --title="Redirecting..." -- sleep 0.5
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
