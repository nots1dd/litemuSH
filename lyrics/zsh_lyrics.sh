zsh_lyrics() {
    echo -e "\n"
    gum style --padding "1 5" --border double --border-foreground 240 "Lyrics displayed!" "To use keybinds kill the lyrics window!!" "Then, to remove this message, press u or U"
    gum spin --spinner dot --title "Fetching lyrics..." -- sleep 1
    kitty zsh -c "gum pager < '$src/lyrics.md'; exec zsh" >/dev/null 2>&1
}