require "bundler/setup"
require "safe_pusher"
require 'pry'

RSpec.configure do |config|
  config.before(:all) do
    SafePusher.configure do |config|
      config.app_base_directory = %w[lib/]
      config.repo_url = 'https://github.com/williampollet/safe_pusher'
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
