# Convert elapsed time format (HH:MM:SS or MM:SS or SS) to seconds
format_time() {
    local SECONDS=$1
    printf "%02d:%02d:%02d" $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60))
}

