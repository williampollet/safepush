module SafePusher
  class CLI
    attr_reader :arguments

    def initialize(arguments:)
      @arguments = arguments
    end

    def start
      display_help unless arguments_valid?

      arguments.each do |command|
        execute_command(command)
      end
    end

    private

    def inspect_command(command)
      case command
      when 'test', 't'
        test
      when 'lint', 'l'
        lint
      when 'open', 'o'
        push
      when 'push', 'p'
        open
      else
        display_help
      end
    end

    def test
      puts '##########################'.yellow
      puts '## Testing new files... ##'.yellow
      puts '##########################'.yellow
      results = SafePusher::RspecRunner.new.call

      exit results unless results == 0
    end

    def lint
      puts '#######################'.yellow
      puts '## Running linter... ##'.yellow
      puts '#######################'.yellow

      results = SafePusher::ProntoRunner.new.call

      exit results unless results == 0
    end

    def push
      puts '##########################'.yellow
      puts '## Pushing to Github... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::GithubRunner.new.push

      exit results unless results == 0
    end

    def open
      puts '#########################################'.yellow
      puts '## Opening a pull request on Github... ##'.yellow
      puts '#########################################'.yellow

      results = SafePusher::GithubRunner.new.open

      exit results unless results == 0
    end

    def arguments_valid?
      arguments.join(' ') =~ /^(?!\s*$)(?:test|lint|push|open| )+$/
    end

    def display_help
      puts "Usage:\n"\
      ' - test (t) # run the test suite'\
      ' - lint (l) # run the linters'\
      ' - push (p) # push on distant repository'\
      ' - open (o) # open a pull request on the distant repository'
      ' - help (h) # show this usage message'
    end
  end
end
