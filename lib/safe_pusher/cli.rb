module SafePusher
  class CLI < Thor
    desc 'prontorun', 'launch pronto with a return message'
    def prontorun
      puts '#######################'.yellow
      puts "## Running pronto... ##".yellow
      puts '#######################'.yellow

      exit SafePusher::ProntoRunner.new.call
    end

    desc 'test', 'launch the test suite with a return message'
    def test
      puts '##########################'.yellow
      puts "## Testing new files... ##".yellow
      puts '##########################'.yellow

      exit SafePusher::RSpecRunner.new.call
    end

    desc 'pushandpr', 'push your code on github, and open a PR if it is the first time'
    def pushandpr
      puts '##########################'.yellow
      puts "## Pushing to Github... ##".yellow
      puts '##########################'.yellow

      exit SafePusher::GithubRunner.new.call
    end

    desc 'prontotest', 'launch the test suite, then pronto if it is successful'
    def prontotest
      invoke :test
      invoke :prontorun
    end

    desc 'ppush', 'run your favorite linter, then push on github'
    def ppush
      invoke :prontorun
      invoke :pushandpr
    end

    desc 'ppushtest', 'run your favorite linters and tests, then push on github'
    def ppushtest
      invoke :test
      invoke :prontorun
      invoke :pushandpr
    end
  end
end
