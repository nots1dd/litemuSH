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

        # Store the selected song in the variable "selected_song"
        selected_song=$(printf "%s\n" "${song_list[@]}" | gum choose --header "Choose song" --limit=1 --height 30)
        if [ "$selected_song" = "user aborted" ]; then
            gum confirm --default "Exit Litemus?" && exit || queue_func
        else
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
