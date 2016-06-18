require "splitsound/version"
require "splitsound/video_file"
require "splitsound/audio_file"
require "streamio-ffmpeg"
require "fileutils"

module Splitsound
  # Your code goes here...
  def self.run(path_to_file)
    @video_file = VideoFile.new(path_to_file)
    if @video_file.configured?
      puts "Processing video"
      @video_file.check_for_default_config!
      # @video_file.add_to_itunes!
      @video_file.split!
    else
      puts "Writing config file"
      @video_file.write_config_file
    end
  end
end
