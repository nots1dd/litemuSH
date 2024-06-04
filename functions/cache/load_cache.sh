# Previously this function was O(n^2) but now it should be decetly efficient
load_sorted_songs_from_cache() {
    local selected_artist="$1"
    local cache_file="$cache_dir/${selected_artist// /_}.cache"

    mapfile -t song_display_list < "$cache_file" # takes care of the '\n' char given while sorting songs thru albums
    
    # Map song display names back to full song names
    sorted_song_list=()
    for song_display in "${song_display_list[@]}"; do
        song_name="$(ls | grep "$song_display.mp3" | head -n 1)" 
        # NOTE: this will only work if the file name is in the convention "ARTIST - SONG.mp3"
        # it will take the first result from the grep result (in case of conflicting results)
        # for example, if I want to play Numb (linkin park), the grep will show every case where numb is present in a songs name
        sorted_song_list+=("$song_name")
    done
}
