load_songs() {
    mapfile -t song_list < <(find . -maxdepth 1 -type f -name "*.mp3" | sort)
    if [ ${#song_list[@]} -eq 0 ]; then
        echo -e "${RED}No .mp3 files found in the directory.${NC}"
        exit 1
    fi
}