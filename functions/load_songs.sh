load_songs() {
    mapfile -t song_list < <(ls *.mp3 | sort)
}