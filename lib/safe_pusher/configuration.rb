# Configuration variables and defaults
module SafePusher
  class Configuration
    # The configuration singleton
    attr_accessor :test_command,
                  :files_to_test

    def initialize
      @test_command = nil
      @files_to_test = nil
      @repo_url = nil
    end
  end
end
