require "yaml"

module Splitsound
  class VideoFile
    CONFIG_EXTENSION = ".yml"
    VIDEO_EXTENSION = ".mp4"
    CONFIG_DEFAULTS = 
      {'Info' => {'Artist' => "Artist Name Here",
                  'Album' => "Album or Performance Name Here",
                  'Year' => "If you have it (or delete this row)",
                  'Genre' => "Select a Genre (or delete this row)"},
      'Tracks' => {
                    'First Track Title' => {
                      'Start' => '1:00.05',
                      'End' => '4:30'
                    },
                    'Second Track Title' => {
                      'Start' => '5:00.05',
                      'End' => '9:30'
                    }
                  }}
    attr_accessor :filepath, :config, :movie
    def initialize(path_to_file)
      @filepath = path_to_file
      @file = File.basename path_to_file         # => "xyz.mp4"
      @extn = File.extname  path_to_file         # => ".mp4"
      @name = File.basename path_to_file, @extn  # => "xyz"
      @path = File.dirname  path_to_file
      @config = read_config rescue nil
      @movie = FFMPEG::Movie.new(@filepath)
    end

    def check_for_default_config!
      raise "! Edit #{config_file_path} to add artist and track info before proceeding." if @config == CONFIG_DEFAULTS
    end

    def configured?
      !@config.nil?
    end

    def config_file_path
      File.join(@path, (@name + ".yml"))
    end

    def write_config_file
      File.open(config_file_path, 'w') { |f| f.write(CONFIG_DEFAULTS.to_yaml) }
    end

    def read_config
      YAML.load_file(config_file_path)
    end

    def new_file_name
      filename = "#{@config["Info"]["Artist"]} - #{@config["Info"]["Album"] + VIDEO_EXTENSION}"
      File.join(@path, filename)
    end

    def ffmpeg_options
      ffmpeg_opts = "-codec copy"
      tag_options = @config["Info"].select { |k, v| ["Artist", "Album", "Year", "Genre"].include?(k) }
      tag_options.each do |tag, value|
        tag = "date" if tag == "Year"
        ffmpeg_opts += " -metadata #{tag.downcase}=\"#{value}\""
      end

      ffmpeg_opts += " -metadata title=\"#{@config['Info']['Album']}\""
      # set the type to "music video": https://code.google.com/p/mp4v2/wiki/iTunesMetadata
      ffmpeg_opts += " -metadata stik=6"

      ffmpeg_opts
    end

    def add_to_itunes!
      movie.transcode(new_file_name, ffmpeg_options) { |p| puts "#{@config["Info"]["Artist"]} - #{@config["Info"]["Album"]}: #{p}" }
      FileUtils.mv(new_file_name, "/Users/cb/Music/iTunes/iTunes Media/Automatically Add to iTunes.localized")

      self
    end

    def split!
      puts movie.audio_stream
      config["Tracks"].each do |track_name, track_info|
        opts = config["Info"].merge(track_info).merge({"Title" => track_name})
        AudioFile.new(filepath, opts).create!
      end
    end
  end
end
