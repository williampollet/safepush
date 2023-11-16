module Safepush
  module Client
    class Git
      def amend
        system('git commit --amend')

        $CHILD_STATUS.exitstatus
      end

      def add
        system('git add --interactive')

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
end
