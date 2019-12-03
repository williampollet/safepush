module SafePusher
  module Client
    class Rspec
      def initialize
        @specs_to_execute = []
      end

      def test
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
        puts I18n.t('command.test.file_put_in_test_list', file: file)
        specs_to_execute << file
      end

      def files_to_skip
        Regexp.new(
          SafePusher.configuration.files_to_skip.join('|').gsub('/', '\/'),
        )
      end

      def run_specs
        if specs_to_execute.empty?
          puts I18n.t('command.test.no_spec_analyzed').green
          return 0
        end

        system("bin/rspec #{specs_to_execute.join(' ')}")

        exit_status = $CHILD_STATUS.exitstatus

        if exit_status != 0
          puts spec_failing_or_missing
        else
          puts every_spec_operational
        end

        exit_status
      end

      def create_new_spec(spec_path, file_matched)
        puts I18n.t(
          'command.test.no_spec_found_for_file',
          file_matched: file_matched,
          spec_path: spec_path,
        )

        result = STDIN.gets.chomp

        if result.casecmp('n') == 0
          puts I18n.t('command.test.test_skipped')

          return 0
        else
          create_new_file(spec_path)

          warn I18n.t('command.test.spec_needs_to_be_written').red

          return 1
        end
      end

      def branch
        `git rev-parse --abbrev-ref HEAD`.delete("\n")
      end

      def create_new_file(path)
        parent_directory = path.slice(0, path.rindex('/'))

        FileUtils.mkdir_p(parent_directory) unless File.exist?(parent_directory)
        File.open(path, 'w') {}
      end

      def app_base_directory
        %r{#{SafePusher.configuration.app_base_directory}\/.*\.rb$}
      end

      def base_branch
        SafePusher.configuration.base_branch
      end

      def spec_failing_or_missing
        I18n.t('command.test.spec_failing_or_missing').red
      end

      def every_spec_operational
        I18n.t('command.test.every_spec_operational').green
      end
    end
  end
end
