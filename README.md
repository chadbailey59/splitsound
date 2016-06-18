# Splitsound

Split a video (such as a live concert) into multiple audio files based on start and end times. Splitsound will set metadata in the files and import them into iTunes as well.

You'll need FFMPEG, which you should be able to install with `brew install ffmpeg`. You'll probably also want something to automatically download videos from YouTube; for that I'd recommend [youtube-dl](https://rg3.github.io/youtube-dl/).
To use it:

1. Clone this repo
2. `cd splitsound; bundle install`
2. Download a video with `youtube-dl` or something
3. `bundle exec bin/splitsound video.mp4` will create a config file.
4. Edit the config file with the metadata you want.
5. `bundle exec bin/splitsound video.mp4` again to split the video.
