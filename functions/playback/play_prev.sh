# Play previous song
play_previous() {
    if [ "$current_index" -gt 0 ]; then
        kill "$ffplay_pid" >/dev/null 2>&1
        gum spin --title="Playing previous tune..." -- sleep 0.5
        play_song_at_index $((current_index - 1))
    else
        echo -e "${YELLOW}You are at the first song.${NC}"
    fi
}