increase_volume() {
    amixer -q sset Master 2%+
}

decrease_volume() {
    amixer -q sset Master 2%-
}