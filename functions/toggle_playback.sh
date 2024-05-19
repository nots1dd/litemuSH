# Function to toggle playback status (pause/play)
toggle_playback() {
    if [[ $paused -eq 0 ]]; then
        # If currently playing, pause playback
        if kill -STOP "$ffplay_pid" >/dev/null 2>&1; then
            status_line="${YELLOW}Status: Paused${NC}"
            return 0
        else
            return 1
        fi
    else
        # If currently paused, resume playback
        if kill -CONT "$ffplay_pid" >/dev/null 2>&1; then
            status_line="${GREEN}Status: Playing${NC}"
            return 0
        else
            return 1
        fi
    fi
}