# Function to get duration of a song (ffprobe gets results in seconds ONLY that are floating of 0.6f degree ex. 255.000123)
get_duration() {
    local song="$1"
    time=$(ffprobe -v quiet -print_format json -show_format -show_streams "$song" | jq -r '.format.duration')
    # Convert duration to floating-point number
    duration_seconds=$(echo "$time" | bc -l)
    # Round duration_seconds to the nearest integer
    duration_seconds=$(printf "%.0f" "$duration_seconds") # (not doing this step leads to some weird results on my local machine, modify this function as you need)
    # Calculate minutes and seconds
    minutes=$((duration_seconds / 60))
    seconds=$((duration_seconds % 60))
    printf "%02d:%02d\n" "$minutes" "$seconds"
}