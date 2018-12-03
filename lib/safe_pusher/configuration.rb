# Configuration variables and defaults
module SafePusher
  class Configuration
    # The configuration singleton
    attr_accessor :test_command,
                  :files_to_skip,
                  :app_base_directory,
                  :repo_url

    def initialize
      @test_command = nil
      @files_to_skip = []
      @app_base_directory = nil
      @repo_url = nil
    end
  end
end
