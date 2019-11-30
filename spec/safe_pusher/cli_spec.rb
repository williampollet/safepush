require 'spec_helper'

RSpec.describe SafePusher::CLI do
  describe '#start' do
    subject(:start) { cli.start }

    let(:cli) { described_class.new(arguments: command) }
    let(:tester) { SafePusher::Client::Rspec.new }
    let(:linter) { SafePusher::Client::Pronto.new }
    let(:pusher) { SafePusher::Client::Github.new }
    let(:opener) { SafePusher::Client::Github.new }
    let(:versioner) { SafePusher::Client::Git.new }

    context 'when command is test' do
      let(:command) { ['test'] }

      before do
        allow(SafePusher::Client::Rspec).to receive(:new).and_return(tester)
        allow(tester).to receive(:test).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'launches the tester' do
        start

        expect(tester).to have_received(:test)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).once
      end
    end

    context 'when command is lint' do
      let(:command) { ['lint'] }

      before do
        allow(SafePusher::Client::Pronto).to receive(:new).and_return(linter)
        allow(linter).to receive(:lint).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches the linter' do
        start

        expect(linter).to have_received(:lint)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).once
      end
    end

    context 'with a git command' do
      before do
        allow(SafePusher::Client::Git).to receive(:new).and_return(versioner)
        allow($stdout).to receive(:puts)
      end

      context 'when command is add' do
        let(:command) { ['add'] }

        before do
          allow(versioner).to receive(:add).and_return(0)
        end

        it 'launches the git runner' do
          start

          expect(versioner).to have_received(:add)
        end

        it 'prints the information' do
          start

          expect($stdout).to have_received(:puts).once
        end
      end

      context 'when command is amend' do
        let(:command) { ['amend'] }

        before do
          allow(versioner).to receive(:amend).and_return(0)
        end

        it 'launches the linter' do
          start

          expect(versioner).to have_received(:amend)
        end

        it 'prints the information' do
          start

          expect($stdout).to have_received(:puts).once
        end
      end

      context 'when command is commit' do
        let(:command) { ['commit'] }

        before do
          allow(versioner).to receive(:commit).and_return(0)
        end

        it 'launches the git_runner' do
          start

          expect(versioner).to have_received(:commit)
        end

        it 'prints the information' do
          start

          expect($stdout).to have_received(:puts).once
        end
      end
    end

    context 'when command is push' do
      let(:command) { ['push'] }

      before do
        allow(SafePusher::Client::Github).to receive(:new).and_return(pusher)
        allow(pusher).to receive(:push).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'launches the pusher' do
        start

        expect(pusher).to have_received(:push)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).once
      end
    end

    context 'when command is open' do
      let(:command) { ['open'] }

      before do
        allow(SafePusher::Client::Github).to receive(:new).and_return(opener)
        allow(opener).to receive(:open).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'lanches the linter' do
        start

        expect(opener).to have_received(:open)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).once
      end
    end

    context 'when there is several commands' do
      let(:command) { %w[test push] }

      before do
        allow(SafePusher::Client::Rspec).to receive(:new).and_return(tester)
        allow(SafePusher::Client::Github).to receive(:new).and_return(pusher)
        allow(pusher).to receive(:push).and_return(0)
        allow(tester).to receive(:test).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'prints the informations' do
        start

        expect($stdout).to have_received(:puts).twice
      end

      it 'launches the tests' do
        start

        expect(tester).to have_received(:test)
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
      context 'when there are several commands' do
        let(:command) { %w[t p] }

        before do
          allow(SafePusher::Client::Rspec)
            .to receive(:new).and_return(tester)
          allow(SafePusher::Client::Github).to receive(:new).and_return(pusher)
          allow(pusher).to receive(:push).and_return(0)
          allow(tester).to receive(:test).and_return(0)
          allow($stdout).to receive(:puts)
        end

        it 'prints the information' do
          start

          expect($stdout).to have_received(:puts).twice
        end

        it 'launches the tests' do
          start

          expect(tester).to have_received(:test)
        end

        it 'pushes' do
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
