# LITEMUS
## A light music player written entirely on shell

### Dependencies
-> ffmpeg [AUR PACKAGE]

-> ffplay and ffprobe (part of ffmpeg family)

-> gum [AUR PACKAGE] or [github](https://github.com/charmbracelet/gum)

-> bc (basic calculator) [AUR PACKAGE]

-> jq (to parse json) [AUR PACKAGE]

-> Common unix utils like grep, awk, wc

### Features (Currently)
1. Very light weight (no bloat)
2. Efficient extraction of a downloaded song's metadata (**thumbnail**, **duration**, **lyrics** and so on)
3. A basic yet clean tui to interact with thanks to gum
4. Essential options like Pause, Play, Quit, volume control and player control (prev/next song/restart song) all are implemented
5. Ability to add items to queue and play them
6. Sorting of songs by album, track and disc using metadata (works decently fast, also is cached)
7. Other modes like `kill and return` and `silent return` and `lyrics view` are also available
8. Easy **THEME** configuration read `.config/themes/theme_conf.md`
9. Cache of songs and other data for faster parsing and efficiency (setup `.cache`)

In terms of watt-hours consumed by the entire process, it was on average **5-8.5m/s** (seen on powertop)
![2024-05-14_17-27-25](https://github.com/nots1dd/litemus/assets/140317709/3293cb4a-cd03-4f4d-a425-c1b2497dcf0b)


### INSTALLATION GUIDE
#### NOTE: Currently this is tried and tested only on Arch Linux (6.8.9-zen1-1-zen)
#### USING PKGBUILD
If you want to install lmus using `PKGBUILD`:

-> Download the `PKGBUILD` file ONLY 

-> Whichever chosen directory it is downloaded in, run `makepkg -si`

#### CLONING REPOSITORY
1. Building Requirements :

Since ffmpeg is a vital tool in most operating systems, and smenu can be built in virtually any unix based OS, **building** all the dependencies is not a big issue.
Feel free to let me know if there is an issue in any linux distro or not.

-> Other packages you can just install them using `yay`

NOTE :: You need to have `.mp3` files in your `~/Downloads/Songs` directory at this time. I will soon change this be user defined directory soon.

-> There is no current plans for expansion of litemus outside linux (will consider macos)

2. Installation :

-> After ensuring all dependencies are present in your local machine, you can just clone this repository and run the script `install.sh` which will add an alias to your shell rc

-> Then you should be able to run `lmus` anywhere and it will work

In case it DOES NOT work, check the following :

a. In `main.sh` the `$src` and other variables should be the directory where you cloned litemus

b. If you do not have proper song metadata (might be a random mp3 file), lmus is NOT BUILT to play such media and will bug out in its UX

c. Enter the **full directory** in the song directory prompt (tilde `~` does NOT work)

d. Make sure you have run `install.sh` FIRST before running lmus (install script also might be a bit broken, you cannot fully rely on it)

**NOTE :: YOU SHOULD RUN THIS SCRIPT AT YOUR OWN DISCRETION, BE AWARE OF WHAT THE SCRIPT DOES AND ITS FUNCTIONALITIES BEFORE EXECUTING.**

### CONFIGURATION
#### Themes:
At the moment, there is a simple `.config/themes/theme.json` which has my config in it, which is being called by `jq`. Feel free to create a pr with more unique and clean themes

-> For more information on how the `theme.json` works, look at `.config/themes/theme_conf.md`

#### Keybinds:
Similar to themes, there is a `.config/keybinds/keybinds.json` where you can update keybinds as you wish

(tip: While in player, there is a reload_theme && reload_keys keybind `default keybind: u` that will auto_reload BOTH theme and keybinds)

#### DE / WM:
As I use Hyprland, here are some things I recommend to add to your `hyprland.conf` to get the best out of litemus

`windowrulev2 = float,class:^(kitty)$,title:^(lmus)$`

`windowrulev2 = move 500 50,class:^(kitty)$,title:^(lmus)$`

`windowrulev2 = size 50% 90%,class:^(kitty)$,title:^(lmus)$`

For other distros recommendations / integrations that will make litemus look and work amazing, test it out yourself and create a pr

### SPOTDL
#### Initial Spotdl setup (On `ARCH LINUX`)
-> Install `python-pipx` AUR package

-> Run `pipx install spotdl`

-> To test spotdl out yourself, run `pipx run spotdl download [song_url]`

-> Note: To ensure if the environment variable for pipx is set to the right path, run `pipx ensurepath`

### FUTURE
- [x] Update script to accept characters like `'` and others **[priority/high]**

- [x] To implement a queue feature first (have to initialize a songs directory as an array probably) **[priority/high]**

- [ ] Furnish the script in a tmux like environment (for a cleaner look and better tui experience) **[priority/med]**

- [ ] Add support for other audio formats (right now only `.mp3` is tested) **[priority/low]**

- [x] Previous and Next play should also be implemented **[priority/high]**

- [ ] Integration of spotdl [github](https://github.com/spotDL/spotify-downloader) **[priority/med]**

- [ ] Possibly make this an AUR package after all implementations
