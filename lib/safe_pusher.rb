require 'safe_pusher/configuration'
require 'thor'
require 'colorize'
require 'safe_pusher/cli'
require 'safe_pusher/version'
require 'safe_pusher/git_runner'
require 'safe_pusher/rspec_runner'
require 'safe_pusher/pronto_runner'
require 'safe_pusher/github_runner'

module SafePusher
  # Configuration setup
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
