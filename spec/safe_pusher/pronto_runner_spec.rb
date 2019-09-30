require 'spec_helper'

RSpec.describe SafePusher::ProntoRunner do
  describe '#call' do
    subject(:run_pronto) { pronto_runner.call }

    let(:pronto_runner) { described_class.new }

    before do
      allow(pronto_runner).to receive(:system)
    end

    it 'runs pronto' do
      run_pronto

      expect(pronto_runner).to(
        have_received(:system).with('bin/pronto run --exit-code -c master'),
      )
    end

    context 'when pronto found errors' do
      before do
        allow($stderr).to receive(:write)
        allow($CHILD_STATUS).to receive(:exitstatus).and_return(1)
      end

      it 'prints that an error has been found' do
        run_pronto

        expect($stderr).to(
          have_received(:write).with(
            a_string_including('Pronto found somme errors…'),
          ).once,
        )
      end

      it 'returns 1' do
        expect(run_pronto).to eq(1)
      end
    end

    context 'when pronto did not find any errors' do
      before do
        allow($CHILD_STATUS).to receive(:exitstatus).and_return(0)
        allow($stdout).to receive(:puts)
      end

      it 'prints that no errors have been found' do
        run_pronto

        expect($stdout).to have_received(:puts)
      end

      it 'returns 0' do
        expect(run_pronto).to eq(0)
      end
    end
  end
end
