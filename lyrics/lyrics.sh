zsh_lyrics() {
    gum style --padding "1 5" --border double --border-foreground 240 "To go back, press u|U"
    gum spin --spinner dot --title "Fetching lyrics..." -- sleep 1
    kitty zsh -c "gum pager < '/home/s1dd/misc/litemus/lyrics.md'; exec zsh" >/dev/null 2>&1
}