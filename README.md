# LITEMUS
## A light music player written entirely on shell

### Dependencies
-> ffmpeg [AUR PACKAGE]

-> ffplay and ffprobe (part of ffmpeg family)

-> gum [AUR PACKAGE] or [github](https://github.com/charmbracelet/gum)

-> bc (basic calculator) [AUR PACKAGE]

-> Common unix utils like grep, awk, wc and jq

### Features (Currently)
1. Very light weight (no bloat)
2. Efficient extraction of a downloaded song's metadata (thumbnail, duration and lyrics only for now)
3. A basic yet clean tui to interact with thanks to gum
4. Essential options like Pause, Play, Quit, volume control and player control (prev/next song) all are implemented
5. Other modes like `kill and return` and `silent return` and `lyrics view` are also available

In terms of watt-hours consumed by the entire process, it was on average **5-8.5m/s** (seen on powertop)
![2024-05-14_17-27-25](https://github.com/nots1dd/litemus/assets/140317709/3293cb4a-cd03-4f4d-a425-c1b2497dcf0b)


### INSTALLATION GUIDE
#### NOTE: Currently this is tried and tested only on Arch Linux (6.8.9-zen1-1-zen)
1. Building Requirements :

Since ffmpeg is a vital tool in most operating systems, and smenu can be built in virtually any unix based OS, **building** all the dependencies is not a big issue.
Feel free to let me know if there is an issue in any linux distro or not.

-> Other packages you can just install them using `yay`

NOTE :: You need to have `.mp3` files in your `~/Downloads/Songs` directory at this time. I will soon change this be user defined directory soon.

-> There is no current plans for expansion of litemus outside linux (will consider macos)

2. Installation :

-> After ensuring all dependencies are present in your local machine, you can just clone this repository and run the script `install.sh` which will add an alias to your shell rc

-> Then you should be able to run `lmus` anywhere and it will work
**NOTE :: YOU SHOULD RUN THIS SCRIPT AT YOUR OWN DISCRETION, BE AWARE OF WHAT THE SCRIPT DOES AND ITS FUNCTIONALITIES BEFORE EXECUTING.**

### FUTURE
- [x] Update script to accept characters like `'` and others **[priority/high]**

- [ ] To implement a queue feature first (have to initialize a songs directory as an array probably) **[priority/high]**

- [ ] Furnish the script in a tmux like environment (for a cleaner look and better tui experience) **[priority/med]**

- [ ] Add support for other audio formats (right now only `.mp3` is tested) **[priority/low]**

- [x] Previous and Next play should also be implemented **[priority/high]**

- [ ] Integration of spotdl [github](https://github.com/spotDL/spotify-downloader) **[priority/med]**

- [ ] Possibly make this an AUR package after all implementations
