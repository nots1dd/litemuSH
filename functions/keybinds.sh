keybinds() {
    time=""
    # Loop to continuously handle user input
    while kill -0 $ffplay_pid 2>/dev/null; do
        if [[ $paused -eq 0 ]]; then
            time=$(ps -o etime= --no-headers -p $ffplay_pid)
        fi
        read -t 1 -n 1 -s key
        case $key in
            p|P)
                toggle_ffplayback
                if [[ $paused -eq 0 ]]; then
                    paused=1
                else
                    paused=0
                fi
                ;;
            t|T)
                # Return to song selection menu
                kill "$ffplay_pid" >/dev/null 2>&1
                clear
                play
                ;;
            s|S)
                # go back silently
                clear
                play
                ;;
            n|N)
                # Play next song in queue
                ffplay_next_in_queue
                ;;
            b|B)
                # play previous song in queue
                ffplay_prev_in_queue
                ;;
            q|Q)
                kill "$ffplay_pid" >/dev/null 2>&1
                echo "" > "$src/lyrics.md" # clean the file when quitting
                echo -e "\n${RED}Exiting...${NC}"
                exit
                ;;
            c|C)
                # Check current position
                status_line="\rPlayback:$time"
                ;;
            l|L)
                # Extract and display lyrics
                status_line=""
                sleep 0.5
                get_lyrics "${queue[$current_index]}"
                ;;
            u|U)
                clear
                display_song_info_minimal "${queue[$current_index]}" "$duration"
                ;;
            h|H)
                clear
                display_help
                ;;
            j|J)
                increase_volume
                ;;
            k|K)
                decrease_volume
                ;;
            a|A)
                # Add song to queue
                clear
                queue_func
                ;;
            d|D)
                # display the queue
                clear
                display_queue
                ;;
            # f|F)
            #     forward_song_5_seconds
            #     ;;
            r|R)
                ffrestart_song
                ;;
            x|X)
                kill "$ffplay_pid" >/dev/null 2>&1
                clear
                queue=() # remove queue
                directory_func # change directory
                main
                ;;
                
            *)
                continue
                ;;
        esac
        echo -ne "\r\033[K$status_line"
    done
}