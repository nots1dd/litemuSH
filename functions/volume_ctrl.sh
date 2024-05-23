increase_volume() {
    amixer -q sset Master 2%+
    # have to set volume control for other pipelines not just alsa-utils
}

decrease_volume() {
    amixer -q sset Master 2%-
}