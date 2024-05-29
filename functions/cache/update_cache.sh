# currently not working will fix
update_cache() {
    clear
    display_logo
    gum style --padding "$gum_padding" --border double --border-foreground "$gum_border_foreground" "Select artist to cache"
    
    # Select artist using gum
    cache_selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); gsub("_", " ", artist); gsub(/^ +| +$/, "", artist); print artist}' | sort -u | gum choose --cursor-prefix=1 --header "$gum_select_artist_message" --cursor.foreground "$gum_selected_cursor_foreground" --selected.foreground "$gum_selected_text_foreground" --header.foreground "$gum_header_foreground" --limit 1 --height $gum_height)
    
    if [ -n "$cache_selected_artist" ]; then
        # Delete existing cache file if it exists
        cache_file="$cache_dir/${cache_selected_artist// /_}.cache"
        rm -f "$cache_file"
        
        # Sort and save songs to cache
        sort_songs_by_album "$cache_selected_artist"
        save_sorted_songs_to_cache "$cache_selected_artist"
        gum spin --title="Caching artist..." -- sleep 0.2
        status_line="Artist $cache_selected_artist's cache updated."
    else
        status_line="No artist selected for caching."
    fi
    
    clear
    display_song_info_minimal "${queue[$current_index]}" "$duration"
}