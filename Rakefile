require "bundler/gem_tasks"
require "rspec/core/rake_task"

# Rspec
RSpec::Core::RakeTask.new(:spec)

# RuboCop
require 'rubocop/rake_task'
RuboCop::RakeTask.new

task :default => %i[spec, rubocop]
