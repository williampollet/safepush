require 'safe_pusher/files_analyzer'

files_to_skip = %w[
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

SafePusher::FilesAnalyzer.new(
  test_command: 'zeus test',
  files_to_skip: files_to_skip,
).call
