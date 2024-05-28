save_sorted_songs_to_cache() {
    local cache_file="$cache_dir/${selected_artist// /_}.cache"
    rm -f "$cache_file"
    for song in "${sorted_song_list[@]}"; do
        song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
        if [ "$song_name" != "" ] || [ -z "$song_name" ]; then
            echo "$song_name" >> "$cache_file"
        fi
    done

}

# sorting is by album + track + disc (if present)
sort_songs_by_album() {
    local selected_artist="$1"

    # Sort songs by album, disc, and track number using ffprobe
    declare -A album_sorted_songs

    for song in "${song_list[@]}"; do
        album=$(ffprobe -v quiet -print_format default=nw=1:nk=1 -show_entries format_tags=album "$song")
        album=${album:-"Unknown Album"}
        
        track_info=$(ffprobe -v quiet -print_format default=nw=1:nk=1 -show_entries format_tags=track "$song")
        track=$(echo "$track_info" | awk -F '/' '{ print $1 }')
        track=${track:-0}  # Default track number to 0 if not found or empty

        disc_info=$(ffprobe -v quiet -print_format default=nw=1:nk=1 -show_entries format_tags=disc "$song")
        disc=$(echo "$disc_info" | awk -F '/' '{ print $1 }')
        disc=${disc:-0}  # Default disc number to 0 if not found or empty

        # Pad disc and track number with zeros for proper sorting
        track=$(printf "%04d" "$track")
        disc=$(printf "%04d" "$disc")

        # Append song to album_sorted_songs array with a key "album disc track"
        album_sorted_songs["$album"]+="$disc$track:$song"$'\n'
    done

    # Convert associative array to a list of songs sorted by album, disc, and track number
    sorted_song_list=()
    song_display_list=()

    for album in "${!album_sorted_songs[@]}"; do
        # Sort the songs within each album by disc and track number
        sorted_album_songs=$(echo -e "${album_sorted_songs["$album"]}" | sort)

        # Add sorted songs to the sorted_song_list
        while IFS= read -r line; do
            song="${line#*:}"
            [ -n "$song" ] && sorted_song_list+=("$song")
        done <<< "$sorted_album_songs"
    done

    # Create song display list
    for song in "${sorted_song_list[@]}"; do
        song_display_list+=("$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')")
    done
}
