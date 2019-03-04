module SafePusher
  class CLI
    attr_reader :arguments

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
        execute_command(command)
      end
    end

    private

    def execute_command(command)
      case command
      when 'test', 't'
        test
      when 'lint', 'l'
        lint
      when 'open', 'o'
        open
      when 'push', 'p'
        push
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
      arguments.join(' ') =~ /^(?!\s*$)(?:test|lint|push|open|t|l|p|o| )+$/
    end

    def help
      puts "Usage:\n"\
      " help (h) # show this usage message\n"\
      " --version # print SafePusher version\n"\
      " ##########################################################\n"\
      " # you can use any combination of theese commands \n"\
      " ##########################################################\n"\
      " test (t) # run the test suite\n"\
      " lint (l) # run the linters\n"\
      " push (p) # push on distant repository\n"\
      ' open (o) # open a pull request on the distant repository'
    end

    def version
      puts SafePusher::VERSION
    end
  end
end
