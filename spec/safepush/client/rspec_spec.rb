require 'spec_helper'

RSpec.describe Safepush::Client::Rspec do
  subject(:run_specs) { rspec_runner.test }

  let(:rspec_runner) { described_class.new }

  before do
    allow(rspec_runner).to(
      receive(:`).with(a_string_including('git rev-parse')).and_return('test'),
    )
  end

  context 'when there are no files to inspect' do
    before do
      allow($stdout).to receive(:puts)
      allow(rspec_runner).to(
        receive(:`).with(a_string_including('git diff')).and_return(''),
      )
    end

    it 'gets no modified files' do
      run_specs

      expect(rspec_runner).to(
        have_received(:`).with(a_string_including('git rev-parse')).twice,
      )
      expect(rspec_runner).to(
        have_received(:`).with(
          'git diff --diff-filter=A --diff-filter=M'\
          ' --name-only $(git merge-base test master) test',
        ).once,
      )
    end

    it 'logs a message to stdout' do
      run_specs

      expect($stdout).to(
        have_received(:puts).with(
          a_string_including(
            'No spec found, going to the next step',
          ),
        ),
      )
    end
  end

  context 'when there are files to inspect' do
    before do
      allow($stdout).to receive(:puts)
    end

    context 'when the files are in the spec directory' do
      before do
        allow(rspec_runner).to receive(:system)
        allow(rspec_runner).to(
          receive(:`).with(
            a_string_including('git diff'),
          ).and_return('spec/safepush/client/github.rb'),
        )
      end

      it 'runs the spec' do
        run_specs

        expect(rspec_runner).to(
          have_received(:system).with(a_string_including('bin/rspec')),
        )
      end
    end

    context 'when the files are in the app base directory' do
      describe 'when the files are filtered by the files_to_skip list' do
        before do
          Safepush.configure do |safepush_config|
            safepush_config.files_to_skip = %w[
              spec/spec_helper
              lib/safepush/client/github
            ]
          end

          allow(rspec_runner).to receive(:system)
          allow(rspec_runner).to(
            receive(:`).with(
              a_string_including('git diff'),
            ).and_return('lib/safepush/client/github.rb'),
          )
        end

        after do
          Safepush.configure do |safepush_config|
            safepush_config.files_to_skip = %w[
              spec/spec_helper
            ]
          end
        end

        it 'does not runs any spec' do
          run_specs

          expect(rspec_runner).not_to(
            have_received(:system).with(a_string_including('bin/rspec')),
          )
        end
      end

      context 'when the files are not filtered' do
        before do
          allow(rspec_runner).to(
            receive(:`).with(
              a_string_including('git diff'),
            ).and_return('lib/safepush/client/github.rb'),
          )
          allow(rspec_runner).to(
            receive(:system).with(a_string_including('bin/rspec')),
          )
        end

        context 'when the spec exists' do
          it 'launches the specs' do
            run_specs

            expect(rspec_runner).to(
              have_received(:system).with(a_string_including('bin/rspec')),
            )
          end

          context 'when the specs pass' do
            before do
              allow($stdout).to receive(:puts)
              allow($CHILD_STATUS).to receive(:exitstatus).and_return(0)
            end

            it 'returns a congratulations message' do
              run_specs

              expect($stdout).to(
                have_received(:puts).with(
                  a_string_including(
                    'Every spec operational, going to the next step!',
                  ),
                ),
              )
            end
          end

          context 'when the spec fail' do
            before do
              allow($stdout).to receive(:puts)
              allow($CHILD_STATUS).to receive(:exitstatus).and_return(1)
            end

            it 'returns a warning message' do
              run_specs

              expect($stdout).to(
                have_received(:puts).with(
                  a_string_including(
                    'Oops, a spec seems to be red or empty',
                  ),
                ),
              )
            end
          end
        end

        context 'when the spec does not exist' do
          context 'when the user does not want to create it' do
            before do
              allow(rspec_runner).to(
                receive(:`).with(
                  a_string_including('git diff'),
                ).and_return('lib/safepush/github_runner_with_no_specs.rb'),
              )
              allow(STDIN).to receive(:gets).and_return(
                double('getter', chomp: 'n'),
              )
              allow($stdout).to receive(:puts)
            end

            it 'asks the user if he wants to create the spec' do
              run_specs

              expect(STDIN).to have_received(:gets)
            end

            it 'prints a feedback message and return 0' do
              run_specs

              expect($stdout).to(
                have_received(:puts).with(
                  a_string_including('Alright, skipping the test for now'),
                ),
              )
            end
          end

          context 'when the user wants to create the spec' do
            before do
              allow(rspec_runner).to(
                receive(:`).with(
                  a_string_including('git diff'),
                ).and_return('lib/safepush/github_runner_with_no_specs.rb'),
              )
              allow(STDIN).to receive(:gets).and_return(
                double('getter', chomp: 'Y'),
              )
              allow(File).to receive(:open)
              allow($stderr).to receive(:write).and_return(true)
            end

            it 'asks the user if he wants to create the spec' do
              run_specs

              expect(STDIN).to have_received(:gets)
            end

            it 'creates a spec in the correct directory' do
              run_specs

              expect(File).to have_received(:open)
            end

            it 'warns the user that a spec have to be written' do
              run_specs

              expect($stderr).to(
                have_received(:write).with(
                  a_string_including('A spec needs to be written'),
                ),
              )
            end
          end
        end
      end
    end

    context 'when the files are not in the app base directory' do
      before do
        allow(rspec_runner).to(
          receive(:`).with(
            a_string_including('git diff'),
          ).and_return('exe/github_runner.rb'),
        )
        allow(rspec_runner).to(
          receive(:system).with(a_string_including('bin/rspec')),
        )
      end

      it 'does not launch the specs' do
        run_specs

        expect(rspec_runner).not_to(
          have_received(:system).with(a_string_including('bin/rspec')),
        )
      end
    end
  end
end
