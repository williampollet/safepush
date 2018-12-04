require 'colorize'

module SafePusher
  class RSpecRunner
    def call
      run_specs(list_files_to_execute)
    end

    private

    def list_files_to_execute
      modified_files.map do |f|
        analyze_file(f)
      end.compact
    end

    def modified_files
      `git whatchanged --name-only --pretty="" origin..HEAD`.split("\n").uniq
    end

    def analyze_file(f)
      if f.match(/#{SafePusher.configuration.app_base_directory}\/.*\.rb$/) && !f.match(files_to_skip)
        puts "#{f} has been modified, searching for specs..."

        spec_path = f.gsub("#{SafePusher.configuration.app_base_directory}", 'spec/').gsub('.rb', '_spec.rb')

        if File.exists?(spec_path)
          puts "Spec found for #{f}, putting #{spec_path} in the list of specs to run"
          spec_path
        else
          create_new_spec(spec_path, f)
        end
      elsif !specs_to_execute.include?(f) && !f.match(files_to_skip)
        puts "#{f} modified, putting it in the list of specs to run"
        f
      end
    end

    def files_to_skip
      Regexp.new(SafePusher.configuration.files_to_skip.join('|').gsub('/', '\/'))
    end

    def run_specs(specs_to_execute)
      if specs_to_execute.empty?
        puts 'no spec analyzed, passing to the next step'.green
        0
      end

      system("bin/rspec #{specs_to_execute.join(' ')}")

      exit_status = $?.exitstatus

      if exit_status != 0
        puts 'Oops, a spec seems to be red or empty, be sure to complete it before you push'.red
      else
        puts "Every spec operational, passing to the next step!".green
      end

      exit_status
    end

    def create_new_spec(spec_path, f)
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
  end
end
