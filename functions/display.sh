display_song_info() {
    local song="$1"
    local duration="$2"

    # Extract song name and artist from the file name
    song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
    artist=$(ffprobe -v quiet -print_format json -show_entries format_tags=artist -of default=nw=1:nk=1 "$song")

    status="$3"

    clear

    # Display the song information
    display_logo
    viu --width 24 --height 10 ~/newtmp.png
    disp=$(gum style --padding "1 5" --border double --border-foreground 255 "  $(gum style --foreground 090 'NOW PLAYING')" "" "$(gum style --foreground 180 "$song_name") by $(gum style --foreground 200 "$artist")" "Duration: $(gum style --foreground 066 "$duration")")
    help=$(gum style --padding "1 5" --border double --border-foreground 240 "Pause/Play (p) " "Volume+ (j) Volume- (k)" "Check current position (c)" "Lyrics (l) Go back (u)" "Kill and go back to menu (t) Silently go back to menu (s)" "Quit (q)")
    box=$(gum join "$disp" "$help")
    gum join --align center --vertical "$box"
}