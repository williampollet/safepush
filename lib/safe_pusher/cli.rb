module SafePusher
  class CLI < Thor
    desc 'test (t)', 'launch the test suite with a return message'
    def test
      puts '##########################'.yellow
      puts '## Testing new files... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::RspecRunner.new.call

      exit results unless results == 0
    end
    map t: :test

    desc 'lint (l)', 'launch pronto with a return message'
    def lint
      puts '#######################'.yellow
      puts '## Running pronto... ##'.yellow
      puts '#######################'.yellow

      results = SafePusher::ProntoRunner.new.call

      exit results unless results == 0
    end
    map l: :lint

    desc 'push (p)', 'push your code on github'
    def push
      puts '##########################'.yellow
      puts '## Pushing to Github... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::GithubRunner.new.push

      exit results unless results == 0
    end
    map p: :push

    desc 'open (o)', 'open a pull request on github'
    def open
      puts '#########################################'.yellow
      puts '## Opening a pull request on Github... ##'.yellow
      puts '#########################################'.yellow

      results = SafePusher::GithubRunner.new.open

      exit results unless results == 0
    end
    map o: :open

    desc 'push_and_open (po)', 'push your code on github,'\
         ' and open a Pull Request on Github if none is openned'
    def push_and_open
      puts '##########################'.yellow
      puts '## Pushing to Github... ##'.yellow
      puts '##########################'.yellow

      results = SafePusher::GithubRunner.new.push_and_open

      exit results unless results == 0
    end
    map po: :push_and_open

    desc 'test_and_lint (tl)',
         'launch the test suite, then pronto if it is successful'
    def test_and_lint
      invoke :test
      invoke :lint
    end
    map tl: :test_and_lint

    desc 'lint_push_and_open (lpo)',
         'run your favorite linter, then push on github and open a'\
         ' Pull Request on Github if none is openned'
    def lint_push_and_open
      invoke :lint
      invoke :push_and_open
    end
    map lpo: :lint_push_and_open

    desc 'test_lint_push_and_open (tlpo)',
         'run your favorite linters and tests, then push on github and open'\
         'a Pull Request if none is openned'
    def test_lint_push_and_open
      invoke :test
      invoke :lint
      invoke :push_and_open
    end
    map tlpo: :test_lint_push_and_open
  end
end
