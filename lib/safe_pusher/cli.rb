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
        execute_command(command)
      end
    end

    private

    attr_reader :arguments

    def execute_command(command)
      if SHORTCUTS[command]
        send(SHORTCUTS[command])
      else
        send(command)
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

    def amend
      puts '###################################'.yellow
      puts '## Amending your last commit... ###'.yellow
      puts '###################################'.yellow

      results = SafePusher::GitRunner.new.amend

      exit results unless results == 0
    end

    def add
      puts '######################'.yellow
      puts '## Adding files... ###'.yellow
      puts '######################'.yellow

      results = SafePusher::GitRunner.new.add

      exit results unless results == 0
    end

    def commit
      puts '################################'.yellow
      puts '## Commiting last changes... ###'.yellow
      puts '################################'.yellow

      results = SafePusher::GitRunner.new.commit

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
      arguments.join(' ') =~ valid_commands_regexp
    end

    def valid_commands_regexp
      valid_commands = "#{SHORTCUTS.keys.join('|')}|"\
        "#{SHORTCUTS.values.join('|')}"

      /^(?!\s*$)(?:#{valid_commands}| )+$/
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
      " amend (m) # amend your last commit \n"\
      " add (a) # add changes to be committed \n"\
      " commit (c) # commit your staged changes \n"\
      " push (p) # push on distant repository\n"\
      ' open (o) # open a pull request on the distant repository'
    end

    def version
      puts SafePusher::VERSION
    end
  end
end
