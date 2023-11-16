module Safepush
  module Client
    class Pronto
      def lint
        run_pronto
        exit_status = $CHILD_STATUS.exitstatus

        if exit_status != 0
          warn 'Pronto found somme errors… ' \
               'Fix them before pushing to GitHub!'.red
        else
          puts 'No errors found by pronto, go for next step!'.green
        end

        exit_status
      end

      private

      def run_pronto
        system("bin/pronto run --exit-code -c #{base_branch}")
      end

      def base_branch
        Safepush.configuration.base_branch
      end
    end
  end
end
