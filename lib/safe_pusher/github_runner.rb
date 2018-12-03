require 'colorize'

module SafePusher
  class GithubRunner
    def call
      push_on_github

      exit_status = $?.exitstatus

      if exit_status == 128
        puts "Syncing with github...".green

        push_and_set_upstream

        exit_status = $?.exitstatus

        if exit_status == 0
          open_pull_request_url
        end
      end

      exit_status
    end

    private

    def push_on_github
      `git push origin`
    end

    def push_and_set_upstream
      `git push --set-upstream origin $(git rev-parse --symbolic-full-name --abbrev-ref HEAD)`
    end

    def open_pull_request_url
      `open "#{SafePusher.configuration.repo_url}/pull/new/$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"`
    end
  end
end
