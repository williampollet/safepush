require 'colorize'
require 'English'

module SafePusher
  class GithubRunner
    def push
      system('git push origin')

      exit_status = $CHILD_STATUS.exitstatus

      if exit_status == 128
        puts 'Syncing with github...'.green

        push_and_set_upstream

        exit_status = $CHILD_STATUS.exitstatus
      end

      exit_status
    end

    def open
      system(
        "open '#{SafePusher.configuration.repo_url}/pull/new/#{branch}'",
      )
    end

    private

    def push_and_set_upstream
      system("git push --set-upstream origin #{branch}")
    end

    def branch
      `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.delete("\n")
    end
  end
end
