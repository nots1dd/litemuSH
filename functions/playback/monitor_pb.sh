# not working
monitor_playback() {
    while true; do
        sleep 1
        if [ -n "$ffplay_pid" ]; then
            current_position=$(ps -o etime= -p "$ffplay_pid")
            if [ -z "$current_position" ] || [ "$current_position" = "$duration" ]; then
                ffplay_next_in_queue
                break
            fi
        else
            ffplay_next_in_queue
            break
        fi
    done
}