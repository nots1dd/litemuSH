ffplay_prev_in_queue() {
    if [ "$current_index" -gt 0 ]; then
        current_index=$((current_index - 1))
        killall ffplay >/dev/null 2>&1
        ffplay_song_at_index "$current_index" "false"
    else
        status_line="${YELLOW}Start of queue${NC}"
    fi
}