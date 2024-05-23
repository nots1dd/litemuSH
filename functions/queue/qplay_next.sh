ffplay_next_in_queue() {
    if [ "$current_index" -lt "$((${#queue[@]} - 1))" ]; then
        current_index=$((current_index + 1))
        killall ffplay >/dev/null 2>&1
        ffplay_song_at_index "$current_index"
    else
        status_line="${YELLOW}End of queue${NC}"
    fi
}