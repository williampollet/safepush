require 'yaml'
# Configuration variables and defaults
module SafePusher
  class Configuration
    # The configuration singleton
    attr_accessor :files_to_skip,
                  :app_base_directory,
                  :repo_url,
                  :base_branch,
                  :verbose,
                  :services

    def initialize
      application_config =
        if File.exist?('safe_pusher.yml')
          YAML.load_file('safe_pusher.yml')
        else
          {}
        end

      I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

      @verbose = application_config['verbose'] || true
      @base_branch = application_config['base_branch'] || 'master'
      @files_to_skip = application_config['files_to_skip'] || []
      @app_base_directory = application_config['app_base_directory']
      @repo_url = application_config['repo_url']
      @services = {
        'test' => application_config.dig('services', 'test') || 'rspec',
        'lint' => application_config.dig('services', 'lint') || 'pronto',
        'push' => application_config.dig('services', 'external_hosting') || 'github',
        'open' => application_config.dig('services', 'external_hosting') || 'github',
        'amend' => application_config.dig('services', 'versioning') || 'git',
        'commit' => application_config.dig('services', 'versioning') || 'git',
        'add' => application_config.dig('services', 'versioning') || 'git',
      }
    end
  end
end
