# Play next song
play_next() {
    if [ "$current_index" -lt $((${#song_list[@]} - 1)) ]; then
        kill "$ffplay_pid" >/dev/null 2>&1
        gum spin --title="Playing next tune..." -- sleep 0.5
        play_song_at_index $((current_index + 1))
    else
        echo -e "${YELLOW}You are at the last song.${NC}"
    fi
}