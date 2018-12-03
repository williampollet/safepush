require 'colorize'

module SafePusher
  class ProntoRunner
    def call
      run_pronto
      exit_status = $?.exitstatus

      if exit_status != 0
        $stderr.puts 'Pronto found somme errors... Fix them before pushing to master!'
      else
        puts "No errors found by pronto, go for next step!"
      end

      exit_status
    end

    private

    def run_pronto
      puts `bin/pronto run --exit-code`
    end
  end
end
