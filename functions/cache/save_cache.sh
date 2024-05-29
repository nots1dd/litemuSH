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

# The below function is sort of slow. Feel free to find any inefficiencies in the code and open a pr explaining so
# This appears to be the only aspect of litemus that hinders its speed by a decent margin
# Songs more than 10 take around 4-5 seconds to sort and display
# This is also the reason why we cache this info, so that the next time till the user wants to update cache, it will only take 0.5-1s max to render
# sorting is by album + track + disc (if present)
sort_songs_by_album() {
    local selected_artist="$1"

    # Sort songs by album, disc, and track number using ffprobe
    declare -A album_sorted_songs

    # Read all song metadata in one pass and parse necessary information
    while IFS= read -r song; do
        metadata=$(ffprobe -v quiet -print_format json -show_entries format_tags=album,track,disc "$song")
        album=$(echo "$metadata" | jq -r '.format.tags.album // "Unknown Album"')
        track=$(echo "$metadata" | jq -r '.format.tags.track // "0"' | awk -F '/' '{ print $1 }')
        disc=$(echo "$metadata" | jq -r '.format.tags.disc // "0"' | awk -F '/' '{ print $1 }')

        # Pad disc and track number with zeros for proper sorting
        track=$(printf "%04d" "$track")
        disc=$(printf "%04d" "$disc")

        # Append song to album_sorted_songs array with a key "album disc track"
        album_sorted_songs["$album"]+="$disc$track:$song"$'\n'
    done < <(printf "%s\n" "${song_list[@]}")

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
        song_display_list+=("$(basename "$song" .mp3 | awk -F ' - ' '{ print $2 }')")
    done
}
