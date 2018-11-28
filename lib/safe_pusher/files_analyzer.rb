require 'colorize'

module SafePusher
  class FilesAnalyzer
    def initialize(test_command:, create_specs: true, files_to_skip: [])
      @modified_files = `git whatchanged --name-only --pretty="" origin..HEAD`
        .split("\n")
        .uniq
      @test_command = test_command
      @specs_to_execute = []
      @create_specs = create_specs
      @files_to_skip = files_to_skip
    end

    def call
      list_files_to_execute
      run_specs
    end

    private

    attr_reader :modified_files, :specs_to_execute, :test_command, :create_specs

    def list_files_to_execute
      modified_files.each do |f|
        analyze_file(f)
      end
    end

    def analyze_file(f)
      if f.match(/app\/.*\.rb$/) && !f.match(files_to_skip)
        puts "#{f} has been modified, searching for specs..."

        spec_path = f.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')

        if File.exists?(spec_path)
          puts "Spec found for #{f}, putting #{spec_path} in the list of specs to run"
          specs_to_execute << spec_path
        else
          create_new_spec(spec_path, f)
        end
      elsif !specs_to_execute.include?(f) && !f.match(files_to_skip)
        puts "#{f} modified, putting it in the list of specs to run"
        specs_to_execute << f
      end
    end

    def run_specs
      if specs_to_execute.empty?
        puts 'no spec analyzed, passing to the next step'.green
        return true
      end

      system("#{test_command} #{specs_to_execute.join(' ')}")
      if $?.exitstatus != 0
        puts 'Oops, a spec seems to be red or empty, be sure to complete it before you push'.red
        return false
      else
        puts "Every spec operational, passing to the next step!".green
        return true
      end
    end

    def create_new_spec(spec_path, f)
      return unless create_specs

      puts "no spec found for file #{f}, would you like to add #{spec_path}? (Yn)"
      result = gets.chomp

      if result.downcase == 'n'
        puts 'Alright, skipping the test for now!'
      else
        f = File.open(spec_path, 'w') do |file|
          file.write(template(spec_path))
        end
        raise 'spec to write!'
      end
    end

    def template(spec_path)
      class_name = File.basename(spec_path).gsub('_spec.rb', '').split('_').map(&:capitalize).join
      template = "require \'rails_helper\'\n\nRSpec.describe #{class_name} do\nend"
    end

    def files_to_skip
      Regexp.new(@files_to_skip.join('|').gsub('/', '\/'))
    end
  end
end
