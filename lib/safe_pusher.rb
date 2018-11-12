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
      if `$?` == 1
        return 1
      end

      puts '#######################'.yellow
      puts "## Running pronto... ##".yellow
      puts '#######################'.yellow

      `bundle exec pronto run --exit-code`

      if `$?` != 0
        puts "Pronto found somme errors... Fix them before pushing to master!".red
        return 1
      else
        puts "No errors found by pronto, go for next step!".green
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

      if `$?` == 1
        puts "Oops, a spec seems to be red or empty, be sure to complete it before you push".red
        return 1
      else
        puts "Every spec operational, passing to the next step!".green
      end
    end

    desc 'prontotest', 'launch the test suite, then pronto if it is successful'
    def prontotest
      invoke :testorcreate
      invoke :prontorun
    end
  end
end
