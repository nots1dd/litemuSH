# Previously this function was O(n^2) but now it should be decetly efficient
load_sorted_songs_from_cache() {
    local selected_artist="$1"
    local cache_file="$cache_dir/${selected_artist// /_}.cache"

    mapfile -t song_display_list <  <(grep -v "^$" "$cache_file") # takes care of the '\n' char given while sorting songs thru albums
    
    # Map song display names back to full song names
    sorted_song_list=()
    for song_display in "${song_display_list[@]}"; do
        full_song="$(echo "$selected_artist") - $(echo "$song_display").mp3" # file format
        sorted_song_list+=("$full_song")
    done
}