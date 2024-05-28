# Convert elapsed time format (HH:MM:SS or MM:SS or SS) to seconds
format_time() {
    local SECONDS=$1
    printf "%02d:%02d:%02d" $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60))
}
get_current_position() {
    if [[ $paused -eq 0 ]]; then
        current_time=$(ps -o etime= --no-headers -p $ffplay_pid)
        formatted_time=$(echo "$current_time" | awk -F: '{ if (NF==3) {print ($1 * 3600) + ($2 * 60) + $3} else if (NF==2) {print ($1 * 60) + $2} else {print $1} }')
    fi
}