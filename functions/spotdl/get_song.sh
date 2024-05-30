get_song() {
    # Check if pipx is installed
    if ! command -v pipx &> /dev/null; then
        status_line="pipx is not installed. Please install pipx to use this feature."
        return
    fi

    # Check if spotdl is installed
    if ! pipx list | grep -q 'spotdl'; then
        status_line="spotdl is not installed. Please install spotdl using pipx to use this feature."
        return
    fi

    # Prompt the user for the song link
    song_link=$(gum input --placeholder="Your song link..." --header="Spotdl in litemus" --char-limit=100 --width=80 --header.foreground="$spotdl_header_foreground")

    # Validate the input link
    if [[ "$song_link" =~ ^https://open\.spotify\.com/(track|album)/ ]]; then
        # Use pipx to run spotdl and download the song
        gum style --padding "$gum_padding" --border rounded --border-foreground "$gum_border_foreground" "Downloading song..." "Keybinds will NOT work while downloading the song!!"

        # Run the spotdl command and display the output to the user
        pipx run spotdl download "$song_link"

        # After successful download, load back into Litemus and display song info
        if [ $? -eq 0 ]; then
            clear
            display_song_info_minimal "${queue[$current_index]}" "$duration"
            status_line="${GREEN}Download successful!${NC}"
        else
            clear
            display_song_info_minimal "${queue[$current_index]}" "$duration"
            status_line="${RED}Download failed. Please try again.${NC}"
        fi
    elif [ "$song_link" = "" ]; then
        status_line="${YELLOW}No song chosen.${NC}"
    else
        status_line="Invalid link. Please provide a valid Spotify track or album link."
    fi
}