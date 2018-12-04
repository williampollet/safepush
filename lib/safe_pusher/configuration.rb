require 'YAML'
# Configuration variables and defaults
module SafePusher
  class Configuration
    # The configuration singleton
    attr_accessor :files_to_skip,
                  :app_base_directory,
                  :repo_url

    def initialize
      application_config = YAML.load_file(
        File.join(__dir__, 'safe_pusher.yml'),
      )

      @files_to_skip = application_config['files_to_skip'] || []
      @app_base_directory = application_config['app_base_directory']
      @repo_url = application_config['repo_url']
    end
  end
end
