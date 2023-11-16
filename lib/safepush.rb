require 'safepush/configuration'
require 'thor'
require 'colorize'
require 'English'
require 'i18n'
require 'yaml'
require 'fileutils'
require 'safepush/cli'
require 'safepush/version'
require 'safepush/client/git'
require 'safepush/client/rspec'
require 'safepush/client/pronto'
require 'safepush/client/github'

I18n.config.available_locales = :en

I18n.load_path += ["#{__dir__}/../config/locales/en.yml"]

module Safepush
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
