require 'safe_pusher/configuration'
require 'thor'
require 'colorize'
require 'safe_pusher/cli'
require 'safe_pusher/version'
require 'safe_pusher/files_analyzer'

module SafePusher
  # Configuration setup
  class << self
    attr_writer :configuration

    def configuration
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
