# LITEMUS
## A light music player written entirely on shell

### Dependencies
-> ffmpeg [AUR PACKAGE]

-> ffplay and ffprobe (part of ffmpeg family)

-> smenu [AUR PACKAGE] or [github](https://github.com/p-gen/smenu)

-> Common unix utils like grep, awk

### Features (Currently)
1. Very light weight (no bloat)
2. Efficient extraction of a downloaded song's metadata (thumbnail, duration only for now)
3. A basic yet clean tui to interact with
4. Essential options like Pause, Play, Quit are implemented
5. Other modes like `kill and return` and `silent return` are also available

### INSTALLATION GUIDE
#### NOTE: Currently this is tried and tested only on Arch Linux (6.8.9-zen1-1-zen)
1. Building Requirements :

Since ffmpeg is a vital tool in most operating systems, and smenu can be built in virtually any unix based OS, **building** all the dependencies is not a big issue.
Feel free to let me know if there is an issue in any linux distro or not.
-> There is no current plans for expansion of litemus outside linux (will consider macos)

2. Installation :

-> After ensuring all dependencies are present in your local machine, you can just clone this repository and run the script `install.sh` which will add an alias to your shell rc

-> Then you should be able to run `lmus` anywhere and it will work
**NOTE :: YOU SHOULD RUN THIS SCRIPT AT YOUR OWN DISCRETION, BE AWARE OF WHAT THE SCRIPT DOES AND ITS FUNCTIONALITIES BEFORE EXECUTING.**

### FUTURE
-> Update script to accept characters like `'` and others **[priority/high]**

-> To implement a queue feature first (have to initialize a songs directory as an array probably) **[priority/high]**

-> Furnish the script in a tmux like environment (for a cleaner look and better tui experience) **[priority/med]**

-> Add support for other audio formats (right now only `.mp3` is tested) **[priority/low]**

-> With queue, previous and next play should also be implemented **[priority/high]**

-> Integration of spotdl [github](https://github.com/spotDL/spotify-downloader) **[priority/high]**

-> Possibly make this an AUR package after all implementations
