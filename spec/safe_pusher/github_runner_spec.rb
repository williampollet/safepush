require 'spec_helper'

RSpec.describe SafePusher::GithubRunner do
  let(:github_pusher) { described_class.new }

  describe '#push' do
    subject(:push_on_github) { github_pusher.push }

    before do
      allow(github_pusher).to receive(:system)
    end

    it 'pushes on github' do
      push_on_github

      expect(github_pusher).to(
        have_received(:system).with('git push origin').once,
      )
    end




    context 'when the exit status is 128' do
      before do
        allow(github_pusher).to receive(:system)
        allow($CHILD_STATUS).to receive(:exitstatus).and_return(128, 0)
      end

      it 'pushes and set the branch upstream' do
        push_on_github
        expect(github_pusher).to(
          have_received(:system).with(
            a_string_including('git push --set-upstream origin'),
          ).once,
        )
      end
    end
  end

  describe '#open' do
    subject(:open_pr) { github_pusher.open }

    before do
      allow(github_pusher).to receive(:system)
    end

    it 'opens a pull request on github' do
      open_pr

      expect(github_pusher).to(
        have_received(:system).with(a_string_including('open')),
      )
    end
  end
end
