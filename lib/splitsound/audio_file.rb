module Splitsound
  class AudioFile
    AUDIO_EXTENSION = ".m4a"
    attr_reader :movie, :video_file_path

    def initialize(video_file_path, opts)
      @video_file_path = video_file_path
      @path = File.dirname(@video_file_path)
      @opts = opts
      @movie = FFMPEG::Movie.new(@video_file_path)
    end

    def ffmpeg_options
      ffmpeg_opts = "-vn -acodec copy -ss #{@opts["Start"]} -to #{@opts["End"]}"
      tag_options = @opts.select { |k, v| ["Artist", "Album", "Year", "Genre", "Title"].include?(k) }
      tag_options.each do |tag, value|
        tag = "date" if tag == "Year"
        ffmpeg_opts += " -metadata #{tag.downcase}=\"#{value}\""
      end

      ffmpeg_opts
    end

    def file_name
      filename = "#{@opts["Artist"]} - #{@opts["Title"] + AUDIO_EXTENSION}"
      File.join(@path, filename)
    end

    def create!
      movie.transcode(file_name, ffmpeg_options) { |p| puts "#{@opts["Artist"]} - #{@opts["Title"]}: #{p}" }

      self
    end

    def add_to_itunes!
      FileUtils.mv(file_name, "/Users/cb/Music/iTunes/iTunes Media/Automatically Add to iTunes.localized")

      self
    end

  end
end
