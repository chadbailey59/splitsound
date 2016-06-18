# Splitsound

Split a video (such as a live concert) into multiple audio files based on start and end times. Splitsound will set metadata in the files and import them into iTunes as well.

1. `gem install splitsound` or clone this repo
2. Download a video with `youtube-dl` or something
3. `splitsound video.mp4` will create a config file.
4. Edit the config file with the metadata you want.
5. `splitsound video.mp4` again to split the video.
