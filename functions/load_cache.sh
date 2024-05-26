load_sorted_songs_from_cache() {
    local selected_artist="$1"
    local cache_file="$cache_dir/${selected_artist// /_}.cache"

    mapfile -t song_display_list < <(grep -v '^$' "$cache_file") # takes care of the '\n' char given while sorting songs thru albums
    
    # Map song display names back to full song names
    sorted_song_list=()
    for song_display in "${song_display_list[@]}"; do
        for song in "${song_list[@]}"; do
            song_name=$(echo "$song" | awk -F ' - ' '{ print $2 }' | sed 's/\.mp3//')
            if [ "$song_name" = "$song_display" ]; then
                sorted_song_list+=("$song")
                break
            fi
        done
    done
}