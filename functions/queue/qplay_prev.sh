play_prev_in_queue() {
    if [ "$current_index" -gt 0 ]; then
        current_index=$((current_index - 1))
        play_song_at_index "$current_index"
    else
        status_line="${YELLOW}Start of queue${NC}"
    fi
}