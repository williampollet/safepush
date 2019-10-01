require 'colorize'
require 'English'

module SafePusher
  class GitRunner
    def amend
      system('git commit --amend')

      $CHILD_STATUS.exitstatus
    end

    def add
      system('git add --patch')

      $CHILD_STATUS.exitstatus
    end

    def commit
      puts 'Enter a message for your commit:'

      result = STDIN.gets.chomp

      system("git commit -m '#{result}'")

      $CHILD_STATUS.exitstatus
    end
  end
end
