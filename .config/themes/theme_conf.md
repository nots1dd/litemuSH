## Theme Configuration

This JSON configuration file defines the visual and textual aspects of your application. Below, you'll find an explanation of each section, detailing which parameters use xterm colors, which are booleans, and a brief description of each parameter's purpose.

### `display_colors`

These parameters control the display colors using xterm color codes.

The following paramters are explained with the example `theme.json`

NOTE :: Look at `.config/themes/colors.md` if you want to understand how xterm color system works

- `border_foreground`: 21 - Color for borders.
- `border_foreground_help`: 102 - Color for help section borders.
- `border_foreground_now_playing`: 68 - Color tfor the entire border of display.
- `foreground_now_playing`: 80 - Color for 'now_playing' text.
- `foreground_song_name`: 140 - Color for song names.
- `foreground_artist`: 68 - Color for artist names.
- `foreground_album`: 105 - Color for album names.
- `foreground_duration`: 66 - Color for song duration text.
- `foreground_next_song_name`: 24 - Color for the next song name.
- `foreground_next_artist`: 25 - Color for the next artist name.
- `foreground_queue_count`: 67 - Color for the current queue count.
- `foreground_total_queue_count`: 69 - Color for the total queue count.
- `foreground_queue_time`: 135 - Color for the total queue time.
- `foreground_bold`: 100 - Color for bold text.

### `messages`

These parameters define textual messages and boolean settings.

- `now_playing`: "NOW PLAYING" - Text to display when a song is playing.
- `show_time_in_queue`: false - Boolean indicating whether to show the time in the queue.

### `gum_colors`

These parameters control the colors for the Gum interface using xterm color codes.

- `border_foreground`: 101 - Color for the border in Gum.
- `header_foreground`: 100 - Color for the header in Gum.
- `selected_cursor_foreground`: 67 - Color for the cursor when an item is selected.
- `selected_text_foreground`: 65 - Color for the selected text.
- `selected_artist`: 67 - Color for the selected artist name.
- `artist_foreground`: 68 - Color for artist names.
- `padding`: "1 4" - Padding setting (not a color code).
- `height`: 35 - Height setting (not a color code).
- `error`: 160 - Color for error messages.

### `gum_messages`

These parameters define the selection messages in the Gum interface.

- `select_artist`: "Choose your artist" - Prompt message for selecting an artist.
- `select_song`: "Choose your song" - Prompt message for selecting a song.

### `gum_confirm_colors`

These parameters control the confirmation dialog colors using xterm color codes.

- `selected_text_foreground`: 2 - Color for selected text in confirmation.
- `unselected_text_foreground`: 240 - Color for unselected text in confirmation.
- `prompt_foreground`: 67 - Color for the confirmation prompt.

### `song_thumbnail`

These parameters control the dimensions of the song thumbnail.

- `width`: 24 - Width of the song thumbnail (not a color code).
- `height`: 10 - Height of the song thumbnail (not a color code).

### Summary

- **Xterm Colors**: Parameters ending in `_foreground` and `error` use xterm color codes.
- **Booleans**: The `show_time_in_queue` parameter is a boolean.
- **Text**: Parameters under `messages` and `gum_messages` contain text prompts.
- **Dimensions and Padding**: `padding`, `height`, `width`, and `height` parameters specify dimensions and padding.

This configuration allows you to customize the look and feel of your application by specifying colors, dimensions, and text messages. Adjust these settings as needed to match your desired theme.