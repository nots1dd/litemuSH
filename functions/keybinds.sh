load_keybinds() {
    local keybinds_file="$1"
    if [ -f "$keybinds_file" ]; then
        toggle_pause=$(jq -r '.keybinds.toggle_pause' "$keybinds_file")
        return_to_song_selection=$(jq -r '.keybinds.return_to_song_selection' "$keybinds_file")
        go_back_silently=$(jq -r '.keybinds.go_back_silently' "$keybinds_file")
        play_next_song=$(jq -r '.keybinds.play_next_song' "$keybinds_file")
        play_previous_song=$(jq -r '.keybinds.play_previous_song' "$keybinds_file")
        quit=$(jq -r '.keybinds.quit' "$keybinds_file")
        check_current_position=$(jq -r '.keybinds.check_current_position' "$keybinds_file")
        display_lyrics=$(jq -r '.keybinds.display_lyrics' "$keybinds_file")
        display_minimal_info=$(jq -r '.keybinds.display_minimal_info' "$keybinds_file")
        display_help=$(jq -r '.keybinds.display_help' "$keybinds_file")
        increase_volume=$(jq -r '.keybinds.increase_volume' "$keybinds_file")
        decrease_volume=$(jq -r '.keybinds.decrease_volume' "$keybinds_file")
        add_song_to_queue=$(jq -r '.keybinds.add_song_to_queue' "$keybinds_file")
        display_queue=$(jq -r '.keybinds.display_queue' "$keybinds_file")
        restart_song=$(jq -r '.keybinds.restart_song' "$keybinds_file")
        change_directory=$(jq -r '.keybinds.change_directory' "$keybinds_file")
        reload_theme=$(jq -r '.keybinds.reload_theme' "$keybinds_file")
    else
        status_line="Keybinds file not found!"
    fi
}


keybinds() {
    time=""
    local keybinds_file="$src/.config/keybinds/keybinds.json"
    load_keybinds "$keybinds_file"
    # Loop to continuously handle user input
    while kill -0 $ffplay_pid 2>/dev/null; do
        get_current_position
        read -t 1 -n 1 -s key
        case $key in
            $toggle_pause)
                toggle_ffplayback
                if [[ $paused -eq 0 ]]; then
                    paused=1
                else
                    paused=0
                fi
                ;;
            $return_to_song_selection)
                kill "$ffplay_pid" >/dev/null 2>&1
                clear
                queue=() # empty the queue (t should be pressed as a restart to music session)
                play
                ;;
            $go_back_silently)
                clear
                play
                ;;
            $play_next_song)
                ffplay_next_in_queue
                ;;
            $play_previous_song)
                ffplay_prev_in_queue
                ;;
            $quit)
                kill "$ffplay_pid" >/dev/null 2>&1
                echo "" > "$src/lyrics.md" # clean the file when quitting
                rm -rf "$src/.cache/misc/*"
                echo -e "\n${RED}Exiting...${NC}"
                exit
                ;;
            $check_current_position)
                status_line="\rPlayback:$current_time"
                ;;
            $display_lyrics)
                status_line=""
                sleep 0.5
                get_lyrics "${queue[$current_index]}"
                ;;
            $display_minimal_info)
                clear
                display_song_info_minimal "${queue[$current_index]}" "$duration"
                status_line="" # set this to null so that the previous status line doesnt get echoed
                ;;
            $display_help)
                display_help
                status_line=""
                ;;
            $increase_volume)
                increase_volume
                ;;
            $decrease_volume)
                decrease_volume
                ;;
            $add_song_to_queue)
                clear
                queue_func
                ;;
            $display_queue)
                clear
                display_queue
                ;;
            $restart_song)
                ffrestart_song
                ;;
            $change_directory)
                kill "$ffplay_pid" >/dev/null 2>&1
                clear
                queue=() # remove queue
                directory_func # change directory
                main
                ;;
            $reload_theme)
                reload_theme && reload_keys
                display_song_info_minimal "${queue[$current_index]}" "$duration"
                sleep 0.2
                status_line="Theme and keybinds reloaded."
                ;;
            *)
                continue
                ;;
        esac
        echo -ne "\r\033[K$status_line"
    done
}

reload_keys() {
    if load_keybinds "$keybinds_file"; then
        return
    else
        echo "Failed to reload keybinds."
    fi
}