module SafePusher
  class CLI
    def initialize(arguments:)
      @arguments = arguments
    end

    def start
      return version if arguments.first == '--version'

      help if commands.include?(nil)

      commands.compact.each { |command| execute_command(command) }
    end

    private

    attr_reader :arguments

    def execute_command(command)
      explain(command) if verbose

      results = SafePusher::Client
        .const_get(services[command].capitalize)
        .new
        .public_send(command)

      exit results unless results == 0
    end

    def commands
      @commands ||= arguments.map do |arg|
        next unless arg =~ valid_commands_regexp

        shortcut_to_command[arg] || arg
      end
    end

    def version
      puts SafePusher::VERSION
    end

    def explain(command)
      puts I18n.t("command.#{command}.verbose").yellow
    end

    def help
      puts I18n.t('help')
    end

    def valid_commands_regexp
      @valid_commands_regexp ||= /^(?!\s*$)(?:#{available_commands})$/
    end

    def available_commands
      @available_commands ||= (
        shortcut_to_command.keys + shortcut_to_command.values
      ).join('|')
    end

    def verbose
      @verbose ||= SafePusher.configuration.verbose
    end

    def services
      @services ||= SafePusher.configuration.services
    end

    def shortcut_to_command
      @shortcut_to_command ||= YAML
        .load_file('./config/commands.yml')
        .reduce({}) { |o, (k, v)| o.update(v['shortcut'] => k) }
    end
  end
end
