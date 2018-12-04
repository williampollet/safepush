module SafePusher
  class CLI < Thor
    desc 'prontorun', 'launch pronto with a return message'
    def prontorun
      puts '#######################'.yellow
      puts '## Running pronto... ##'.yellow
      puts '#######################'.yellow

      results = SafePusher::ProntoRunner.new.call

      exit results unless results == 0
    end

    desc 'test', 'launch the test suite with a return message'
    def test
      puts '##########################'.yellow
      puts '## Testing new files... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::RspecRunner.new.call

      exit results unless results == 0
    end

    desc 'pushandpr', 'push your code on github,'\
         ' and open a PR if it is the first time'
    def pushandpr
      puts '##########################'.yellow
      puts '## Pushing to Github... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::GithubRunner.new.call

      exit results unless results == 0
    end

    desc 'ptest', 'launch the test suite, then pronto if it is successful'
    def ptest
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
