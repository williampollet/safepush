require 'spec_helper'

RSpec.describe SafePusher::Client::Git do
  let(:git_runner) { described_class.new }

  describe '#amend' do
    subject(:amend) { git_runner.amend }

    before do
      allow(git_runner).to receive(:system)
    end

    it 'amends the commit' do
      amend

      expect(git_runner).to(
        have_received(:system).with('git commit --amend').once,
      )
    end
  end

  describe '#add' do
    subject(:add) { git_runner.add }

    before do
      allow(git_runner).to receive(:system)
    end

    it 'adds the last changes to be committed' do
      add

      expect(git_runner).to(
        have_received(:system).with('git add --interactive').once,
      )
    end
  end

  describe '#commit' do
    subject(:commit) { git_runner.commit }

    let(:output) { double chomp: 'commit message' }

    before do
      allow(git_runner).to receive(:system)
      allow(STDIN).to receive(:gets).and_return(output)
    end

    it 'creates a git commit' do
      commit

      expect(git_runner).to(
        have_received(:system).with("git commit -m 'commit message'"),
      )
    end
  end
end
