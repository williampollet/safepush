require 'safe_pusher/configuration'
require 'thor'
require 'colorize'
require 'English'
require 'i18n'
require 'yaml'
require 'fileutils'
require 'safe_pusher/cli'
require 'safe_pusher/version'
require 'safe_pusher/client/git'
require 'safe_pusher/client/rspec'
require 'safe_pusher/client/pronto'
require 'safe_pusher/client/github'

I18n.config.enforce_available_locales = false
I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

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
