require 'spec_helper'

RSpec.describe SafePusher::CLI do
  describe '#start' do
    subject(:start) { cli.start }

    let(:cli) { described_class.new(arguments: command) }
    let(:rspec_runner) { SafePusher::RspecRunner.new }
    let(:linter) { SafePusher::ProntoRunner.new }
    let(:pusher) { SafePusher::GithubRunner.new }
    let(:opener) { SafePusher::GithubRunner.new }
    let(:git_runner) { SafePusher::GitRunner.new }

    context 'when command is test' do
      let(:command) { ['test'] }

      before do
        allow(SafePusher::RspecRunner).to receive(:new).and_return(rspec_runner)
        allow(rspec_runner).to receive(:call).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches rspec runner' do
        start

        expect(rspec_runner).to have_received(:call)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).exactly(3).times
      end
    end

    context 'when command is lint' do
      let(:command) { ['lint'] }

      before do
        allow(SafePusher::ProntoRunner).to receive(:new).and_return(linter)
        allow(linter).to receive(:call).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches the linter' do
        start

        expect(linter).to have_received(:call)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).exactly(3).times
      end
    end

    context 'with a git command' do
      before do
        allow(SafePusher::GitRunner).to receive(:new).and_return(git_runner)
        allow($stdout).to receive(:puts)
      end

      context 'when command is add' do
        let(:command) { ['add'] }

        before do
          allow(git_runner).to receive(:add).and_return(0)
        end

        it 'lanches the git runner' do
          start

          expect(git_runner).to have_received(:add)
        end

        it 'prints the informations' do
          start

          expect($stdout).to have_received(:puts).exactly(3).times
        end
      end

      context 'when command is amend' do
        let(:command) { ['amend'] }

        before do
          allow(git_runner).to receive(:amend).and_return(0)
        end

        it 'lanches the linter' do
          start

          expect(git_runner).to have_received(:amend)
        end

        it 'prints the informations' do
          start

          expect($stdout).to have_received(:puts).exactly(3).times
        end
      end

      context 'when command is commit' do
        let(:command) { ['commit'] }

        before do
          allow(git_runner).to receive(:commit).and_return(0)
        end

        it 'lanches the git_runner' do
          start

          expect(git_runner).to have_received(:commit)
        end

        it 'prints the informations' do
          start

          expect($stdout).to have_received(:puts).exactly(3).times
        end
      end
    end

    context 'when command is push' do
      let(:command) { ['push'] }

      before do
        allow(SafePusher::GithubRunner).to receive(:new).and_return(pusher)
        allow(pusher).to receive(:push).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches the pusher' do
        start

        expect(pusher).to have_received(:push)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).exactly(3).times
      end
    end

    context 'when command is open' do
      let(:command) { ['open'] }

      before do
        allow(SafePusher::GithubRunner).to receive(:new).and_return(opener)
        allow(opener).to receive(:open).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches the linter' do
        start

        expect(opener).to have_received(:open)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).exactly(3).times
      end
    end

    context 'when there is several commands' do
      let(:command) { %w[test push] }

      before do
        allow(SafePusher::RspecRunner).to receive(:new).and_return(rspec_runner)
        allow(SafePusher::GithubRunner).to receive(:new).and_return(pusher)
        allow(pusher).to receive(:push).and_return(0)
        allow(rspec_runner).to receive(:call).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).exactly(6).times
      end

      it 'launches the tests' do
        start

        expect(rspec_runner).to have_received(:call)
      end

      it 'pushes on github' do
        start

        expect(pusher).to have_received(:push)
      end
    end

    context 'when command is different from the standard commands' do
      let(:command) { ['touest'] }

      before do
        allow($stdout).to receive(:puts)
      end

      it 'prints the help' do
        start

        expect($stdout).to have_received(:puts)
      end
    end

    context 'with shortcuts' do
      context 'when there is several commands' do
        let(:command) { %w[t p] }

        before do
          allow(SafePusher::RspecRunner).to receive(:new).and_return(rspec_runner)
          allow(SafePusher::GithubRunner).to receive(:new).and_return(pusher)
          allow(pusher).to receive(:push).and_return(0)
          allow(rspec_runner).to receive(:call).and_return(0)
          allow($stdout).to receive(:puts)
        end

        it 'prints the informations' do
          start

          expect($stdout).to have_received(:puts).exactly(6).times
        end

        it 'launches the tests' do
          start

          expect(rspec_runner).to have_received(:call)
        end

        it 'pushes on github' do
          start

          expect(pusher).to have_received(:push)
        end
      end
    end

    context 'when command is --version' do
      let(:command) { ['--version'] }

      before do
        allow($stdout).to receive(:puts)
      end

      it 'outputs the current version' do
        start

        expect($stdout).to have_received(:puts).with(SafePusher::VERSION)
      end
    end
  end
end
