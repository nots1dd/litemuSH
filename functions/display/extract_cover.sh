extract_cover() {
    input_file="$1"
    temp_dir=$(mktemp -d)
    ffmpeg -y -i "$input_file" -an -vcodec copy "$temp_dir/cover_new.png" >/dev/null 2>&1
    echo "$temp_dir/cover_new.png"
}

copy_to_tmp() {
    cp "$1" "$image_dir"
    # echo "Copied!"
}

cleanup_temp_dir() {
    rm -rf "$1"
    # echo "tmp image removed!"
}