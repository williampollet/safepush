module SafePusher
  class Configuration
    attr_accessor :files_to_skip,
                  :app_base_directory,
                  :repo_url,
                  :base_branch,
                  :verbose,
                  :services

    def initialize
      @verbose = application_config['verbose'] || true
      @base_branch = application_config['base_branch'] || 'master'
      @files_to_skip = application_config['files_to_skip'] || []
      @app_base_directory = application_config['app_base_directory']
      @repo_url = application_config['repo_url']
      @services = load_services
    end

    private

    def load_services
      YAML
        .load_file('config/commands.yml')
        .reduce({}) { |o, (k, v)| o.update(k => v['default_client']) }
        .merge(application_config['services'] || {})
    end

    def application_config
      return YAML.load_file('safe_pusher.yml') if File.exist?('safe_pusher.yml')

      {}
    end
  end
end
