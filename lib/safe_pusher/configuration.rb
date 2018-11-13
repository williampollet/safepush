# Configuration variables and defaults
module SafePusher
  # The configuration singleton
  attr_accessor :test_command,
                :filters

  def initialize
    @test_command = 'rspec spec'
    @filters = []
  end

  # Configuration setup
  class << self
    attr_writer :configuration

    def configuration
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)

      if !configuration.test_command
        raise(ArgumentError, 'test command must be set in the configuration')
      end

      configuration
    end
  end
end
