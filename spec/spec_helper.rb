require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'yaml'
require 'safe_pusher'
require 'pry'

RSpec.configure do |config|
  config.before(:each) do
    SafePusher.configure do |safe_pusher_config|
      safe_pusher_config.app_base_directory = 'lib'
      safe_pusher_config.files_to_skip = %w[
        spec/spec_helper
      ]
      safe_pusher_config.repo_url =
        'https://github.com/williampollet/safe_pusher'
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
