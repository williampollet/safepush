require 'yaml'
# Configuration variables and defaults
module SafePusher
  class Configuration
    # The configuration singleton
    attr_accessor :files_to_skip,
                  :app_base_directory,
                  :repo_url,
                  :base_branch

    def initialize
      application_config =
        if File.exist?('safe_pusher.yml')
          YAML.load_file('safe_pusher.yml')
        else
          {}
        end

      @base_branch = application_config['base_branch'] || 'master'
      @files_to_skip = application_config['files_to_skip'] || []
      @app_base_directory = application_config['app_base_directory']
      @repo_url = application_config['repo_url']
    end
  end
end
