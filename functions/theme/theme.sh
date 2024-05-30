load_theme() {
    local theme_file="$1"
    if [ -f "$theme_file" ]; then
        border_foreground=$(jq -r '.display_colors.border_foreground' "$theme_file")
        border_foreground_help=$(jq -r '.display_colors.border_foreground_help' "$theme_file")
        border_foreground_now_playing=$(jq -r '.display_colors.border_foreground_now_playing' "$theme_file")
        foreground_now_playing=$(jq -r '.display_colors.foreground_now_playing' "$theme_file")
        foreground_song_name=$(jq -r '.display_colors.foreground_song_name' "$theme_file")
        foreground_artist=$(jq -r '.display_colors.foreground_artist' "$theme_file")
        foreground_album=$(jq -r '.display_colors.foreground_album' "$theme_file")
        foreground_year=$(jq -r '.display_colors.foreground_year' "$theme_file")
        foreground_genre=$(jq -r '.display_colors.foreground_genre' "$theme_file")
        foreground_duration=$(jq -r '.display_colors.foreground_duration' "$theme_file")
        foreground_next_song_name=$(jq -r '.display_colors.foreground_next_song_name' "$theme_file")
        foreground_next_artist=$(jq -r '.display_colors.foreground_next_artist' "$theme_file")
        foreground_queue_count=$(jq -r '.display_colors.foreground_queue_count' "$theme_file")
        foreground_total_queue_count=$(jq -r '.display_colors.foreground_total_queue_count' "$theme_file")
        foreground_queue_time=$(jq -r '.display_colors.foreground_queue_time' "$theme_file")
        foreground_bold=$(jq -r '.display_colors.foreground_bold' "$theme_file")
        now_playing_message=$(jq -r '.messages.now_playing' "$theme_file")
        # gum colors
        gum_border_foreground=$(jq -r '.gum_colors.border_foreground' "$theme_file")
        gum_selected_artist_color=$(jq -r '.gum_colors.selected_artist' "$theme_file")
        gum_artist_foreground=$(jq -r '.gum_colors.artist_foreground' "$theme_file")
        gum_padding=$(jq -r '.gum_colors.padding' "$theme_file")
        gum_select_artist_message=$(jq -r '.gum_messages.select_artist' "$theme_file")
        gum_select_song_message=$(jq -r '.gum_messages.select_song' "$theme_file")
        gum_height=$(jq -r '.gum_colors.height' "$theme_file")
        gum_selected_cursor_foreground=$(jq -r '.gum_colors.selected_cursor_foreground' "$theme_file")
        gum_selected_text_foreground=$(jq -r '.gum_colors.selected_text_foreground' "$theme_file")
        gum_header_foreground=$(jq -r '.gum_colors.header_foreground' "$theme_file")
        gum_colors_error=$(jq -r '.gum_colors.error' "$theme_file")
        # gum confirm
        gum_confirm_selected_text_foreground=$(jq -r '.gum_confirm_colors.selected_text_foreground' "$theme_file")
        gum_confirm_unselected_text_foreground=$(jq -r '.gum_confirm_colors.unselected_text_foreground' "$theme_file")
        gum_confirm_prompt_foreground=$(jq -r '.gum_confirm_colors.prompt_foregroud' "$theme_file")
        # viu image
        image_width=$(jq -r '.song_thumbnail.width' "$theme_file")
        image_height=$(jq -r '.song_thumbnail.height' "$theme_file")
        # calculate_time_left_in_queue
        show_time_in_queue=$(jq -r '.messages.show_time_in_queue' "$theme_file")
        # spotdl
        spotdl_header_foreground=$(jq -r '.spotdl.header_foreground' "$theme_file")
    else
        gum style --border-foreground "$gum_colors_error" "Theme file not found!"
        sleep 0.5
        exit 1
    fi
}

reload_theme() {
    if load_theme "$theme_dir"; then
        return
    else
        echo "Failed to reload theme."
    fi
}

