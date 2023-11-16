require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'yaml'
require 'safepush'
require 'pry'

RSpec.configure do |config|
  config.before do
    Safepush.configure do |safepush_config|
      safepush_config.base_branch = 'master'
      safepush_config.app_base_directory = 'lib'
      safepush_config.files_to_skip = %w[
        spec/spec_helper
      ]
      safepush_config.repo_url =
        'https://github.com/williampollet/safepush'
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
