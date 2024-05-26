# Main play function
save_sorted_songs_to_cache() {
    local cache_file="$cache_dir/${selected_artist// /_}.cache"
    rm -f "$cache_file"
    for song in "${sorted_song_list[@]}"; do
        song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
        if [ "$song_name" != "\n" ] || [ -z "$song_name" ]; then
            echo "$song_name" >> "$cache_file"
        fi
    done

}

sort_songs_by_album() {
    local selected_artist="$1"

    # Sort songs by album using ffprobe
    declare -A album_sorted_songs
    for song in "${song_list[@]}"; do
        album=$(ffprobe -v quiet -print_format json -show_entries format_tags=album -of default=nw=1:nk=1 "$song")
        album=${album:-"Unknown Album"}
        album_sorted_songs["$album"]+="$song"$'\n'
    done

    # Convert associative array to a list of songs sorted by album
    sorted_song_list=()
    for album in "${!album_sorted_songs[@]}"; do
        mapfile -t album_songs <<< "${album_sorted_songs[$album]}"
        for song in "${album_songs[@]}"; do
            sorted_song_list+=("$song")
    done

    # Create song display list
    song_display_list=()
    for song in "${sorted_song_list[@]}"; do
        song_display_list+=("$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')")
    done
    done
}