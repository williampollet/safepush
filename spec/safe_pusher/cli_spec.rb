require 'spec_helper'

RSpec.describe SafePusher::CLI do
  let(:cli) { described_class.new }

  describe '#test' do
    subject(:test) { cli.test }

    let(:rspec_runner) { SafePusher::RspecRunner.new }

    before do
      allow(SafePusher::RspecRunner).to receive(:new).and_return(rspec_runner)
      allow(rspec_runner).to receive(:call).and_return(0)
      allow($stdout).to receive(:puts)
    end

    it 'lanches rspec runner' do
      test

      expect(rspec_runner).to have_received(:call)
    end

    it 'prints the informations' do
      test

      expect($stdout).to have_received(:puts).exactly(3).times
    end
  end

  describe '#lint' do
    subject(:lint) { cli.lint }

    let(:linter) { SafePusher::ProntoRunner.new }

    before do
      allow(SafePusher::ProntoRunner).to receive(:new).and_return(linter)
      allow(linter).to receive(:call).and_return(0)
      allow($stdout).to receive(:puts)
    end

    it 'lanches the linter' do
      lint

      expect(linter).to have_received(:call)
    end

    it 'prints the informations' do
      lint

      expect($stdout).to have_received(:puts).exactly(3).times
    end
  end

  describe '#push' do
    subject(:push) { cli.push }

    let(:pusher) { SafePusher::GithubRunner.new }

    before do
      allow(SafePusher::GithubRunner).to receive(:new).and_return(pusher)
      allow(pusher).to receive(:push).and_return(0)
      allow($stdout).to receive(:puts)
    end

    it 'lanches the linter' do
      push

      expect(pusher).to have_received(:push)
    end

    it 'prints the informations' do
      push

      expect($stdout).to have_received(:puts).exactly(3).times
    end
  end

  describe '#open' do
    subject(:open) { cli.open }

    let(:opener) { SafePusher::GithubRunner.new }

    before do
      allow(SafePusher::GithubRunner).to receive(:new).and_return(opener)
      allow(opener).to receive(:open).and_return(0)
      allow($stdout).to receive(:puts)
    end

    it 'lanches the linter' do
      open

      expect(opener).to have_received(:open)
    end

    it 'prints the informations' do
      open

      expect($stdout).to have_received(:puts).exactly(3).times
    end
  end
end
