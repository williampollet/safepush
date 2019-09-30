require 'colorize'
require 'English'

module SafePusher
  class RspecRunner
    def initialize
      @specs_to_execute = []
    end

    def call
      return 1 if list_files_to_execute == 1

      run_specs
    end

    private

    attr_reader :specs_to_execute

    def list_files_to_execute
      modified_files.map do |f|
        return 1 if analyze_file(f) == 1
      end.compact
    end

    def modified_files
      diff = 'git diff --diff-filter=A --diff-filter=M --name-only'

      `#{diff} $(git merge-base #{branch} #{base_branch}) #{branch}`
        .split("\n")
        .uniq
    end

    def analyze_file(file)
      if file.match(app_base_directory) &&
         !file.match(files_to_skip)
        search_or_create_spec(file)
      elsif file.match(/spec/) &&
            !specs_to_execute.include?(file) &&
            !file.match(files_to_skip)
        index_file(file)
      end
    end

    def search_or_create_spec(file)
      spec_path = file.gsub(
        "#{SafePusher.configuration.app_base_directory}/",
        'spec/',
      ).gsub('.rb', '_spec.rb')

      return create_new_spec(spec_path, file) unless File.exist?(spec_path)

      puts spec_path

      specs_to_execute << spec_path
    end

    def index_file(file)
      puts "#{file} modified, putting it in the list of specs to run"
      specs_to_execute << file
    end

    def files_to_skip
      Regexp.new(
        SafePusher.configuration.files_to_skip.join('|').gsub('/', '\/'),
      )
    end

    def run_specs
      if specs_to_execute.empty?
        puts 'no spec analyzed, passing to the next step'.green
        return 0
      end

      system("bin/rspec #{specs_to_execute.join(' ')}")

      exit_status = $CHILD_STATUS.exitstatus

      if exit_status != 0
        puts 'Oops, a spec seems to be red or empty, '\
             'be sure to complete it before you push'.red
      else
        puts 'Every spec operational, '\
             'passing to the next step!'.green
      end

      exit_status
    end

    def create_new_spec(spec_path, file_matched)
      puts "no spec found for file #{file_matched},"\
           " would you like to add #{spec_path}? (Yn)"
      result = STDIN.gets.chomp

      if result.casecmp('n') == 0
        puts 'Alright, skipping the test for now!'
        return 0
      else
        File.open(spec_path, 'w') {}
        warn 'A spec needs to be written!'.red
        return 1
      end
    end

    def branch
      `git rev-parse --abbrev-ref HEAD`.delete("\n")
    end

    def app_base_directory
      %r{#{SafePusher.configuration.app_base_directory}\/.*\.rb$}
    end
  end
end
