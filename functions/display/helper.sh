# to implement all this functionality **INCOMPLETE**
print_help() {
    echo "lmus - A lightweight music player written in shell"
    echo
    echo "Usage: lmus [options]"
    echo
    echo "Options:"
    echo "  --help                   Show this help message and exit"
    echo "  --play [song]            Play a specific song"
    echo "  --pause                  Pause the current song"
    echo "  --resume                 Resume the paused song"
    echo "  --stop                   Stop the current song"
    echo "  --next                   Play the next song in the playlist"
    echo "  --prev                   Play the previous song in the playlist"
    echo "  --volume [level]         Set the volume to the specified level"
    echo "  --list                   List all songs in the playlist"
    echo "  --add [song]             Add a song to the playlist"
    echo "  --remove [song]          Remove a song from the playlist"
    echo "  --shuffle                Shuffle the playlist"
    echo
    echo "Examples:"
    echo "  lmus --play 'song.mp3'   Play 'song.mp3'"
    echo "  lmus --volume 50         Set volume to 50%"
    echo "  lmus --list              List all songs in the playlist"
}

# check for lmus --help
if [[ "$1" == "--help" ]]; then
    print_help
    exit 0
# elif [[ "$1" == "--list" ]]; then
#     echo "Invalid Option."
#     exit 1
fi