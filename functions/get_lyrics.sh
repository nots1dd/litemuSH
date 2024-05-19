get_lyrics() {
    local song="$1"
    local lyrics=$(ffprobe -v quiet -print_format json -show_entries format_tags=lyrics-XXX -of default=nw=1:nk=1 "$song" 2>/dev/null)
    local lyrics_file="$HOME/misc/litemus/lyrics.md"  # Ensure the directory exists

    if [ "$lyrics" = "" ]; then
        clear
        gum style --padding "1 5" --border double --border-foreground 240 "Lyrics not available for this song." "To GO BACK press u/U"
    else
        clear

        # Clear the lyrics file before writing new lyrics
        echo "" > "$lyrics_file"

        # Write song title as heading and lyrics to the file
        echo -e "# $song\n\n$lyrics" >> "$lyrics_file"

        # Use kitty, gnome-terminal, alacritty, xterm, or bash to open a new terminal and display the lyrics using gum pager
        if command -v kitty &>/dev/null; then
            zsh_lyrics # only one that has been tested
        elif command -v gnome-terminal &>/dev/null; then
            gnome-terminal -- bash -c "gum pager < '$lyrics_file'; exec bash"
        elif command -v alacritty &>/dev/null; then
            alacritty -e bash -c "gum pager < '$lyrics_file'; exec bash"
        elif command -v xterm &>/dev/null; then
            xterm -e "gum pager < '$lyrics_file'; exec bash"
        elif command -v bash &>/dev/null; then
            bash -c "gum pager < '$lyrics_file'; exec bash"
        else
            echo -e "${RED}No supported terminal found to open lyrics${NC}"
        fi
    fi
}