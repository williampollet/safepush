require 'pry'

module SafePusher
  class CLI
    SHORTCUTS = {
      't' => 'test',
      'l' => 'lint',
      'p' => 'push',
      'o' => 'open',
      'm' => 'amend',
      'a' => 'add',
      'c' => 'commit',
    }.freeze

    private_constant :SHORTCUTS

    def initialize(arguments:)
      @arguments = arguments
    end

    def start
      return version if arguments.first == '--version'

      unless arguments_valid?
        help

        return
      end

      arguments.each do |command|
        execute_command(SHORTCUTS[command] || command)
      end
    end

    private

    attr_reader :arguments

    def execute_command(command)
      explain(command) if verbose

      results = Kernel
        .const_get("SafePusher::Client::#{services[command].capitalize}")
        .new
        .public_send(command)

      exit results unless results == 0
    end

    def arguments_valid?
      arguments.join(' ') =~ valid_commands_regexp
    end

    def valid_commands_regexp
      valid_commands =
        "#{SHORTCUTS.keys.join('|')}|#{SHORTCUTS.values.join('|')}"

      /^(?!\s*$)(?:#{valid_commands}| )+$/
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

    def verbose
      @verbose ||= SafePusher.configuration.verbose
    end

    def services
      @services ||= SafePusher.configuration.services
    end
  end
end
