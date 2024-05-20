# Function to play the next song in the queue
play_next_in_queue() {
    if [ "$current_index" -lt "$((${#queue[@]} - 1))" ]; then
        current_index=$((current_index + 1))
        play_song_at_index "$current_index"
    else
        status_line="${YELLOW}End of queue${NC}"
    fi
}