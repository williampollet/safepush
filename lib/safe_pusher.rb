require 'safe_pusher/version'
require 'safe_pusher/files_analyzer'
require 'thor'
require 'colorize'

module SafePusher
  class CLI < Thor
    FILES_TO_SKIP = %w[
      app/mailer_previews
      app/admin
      spec/rails_helper
      spec/simplecov_helper
      spec/factories
      lib/
      bin/
      client/
      db/
      app/views/
      config
      .rubocop.yml
      circle.yml
      Gemfile
      Gemfile.lock
    ]

    desc 'prontorun', 'launch pronto with a return message'
    def prontorun
      puts '#######################'.yellow
      puts "## Running pronto... ##".yellow
      puts '#######################'.yellow

      `bundle exec pronto run --exit-code`

      if $?.exitstatus != 0
        puts "Pronto found somme errors... Fix them before pushing to master!".red
        false
      else
        puts "No errors found by pronto, go for next step!".green
        true
      end
    end

    desc 'testorcreate', 'launch the test suite with a return message'
    def testorcreate
      puts '##########################'.yellow
      puts "## Testing new files... ##".yellow
      puts '##########################'.yellow

      SafePusher::FilesAnalyzer.new(
        test_command: 'rspec spec',
        files_to_skip: FILES_TO_SKIP,
      ).call
    end

    desc 'pushandpr', 'push your code on github, and open a PR if it is the first time'
    def pushandpr
      puts '##########################'.yellow
      puts "## Pushing to Github... ##".yellow
      puts '##########################'.yellow

      `git push origin`

      if $?.exitstatus == 128
        puts "Syncing with github...".green

        `git push --set-upstream origin $(git rev-parse --symbolic-full-name --abbrev-ref HEAD)`

        if $?.exitstatus == 0
          `open "https://github.com/KissKissBankBank/kisskissbankbank/pull/new/$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"`
        end
      end
    end

    desc 'prontotest', 'launch the test suite, then pronto if it is successful'
    def prontotest
      specs_results = invoke :testorcreate
      return false unless specs_results

      invoke :prontorun
    end

    desc 'ppush', 'run your favorite linter, then push on github'
    def ppush
      linter_results = invoke :prontorun
      return false unless linter_results

      invoke :pushandpr
    end

    desc 'ppushtest', 'run your favorite linters and tests, then push on github'
    def ppushtest
      test_results = invoke :testorcreate
      return false unless test_results

      linter_results = invoke :prontorun
      return false unless linter_results

      invoke :pushandpr
    end
  end
end
