require 'spec_helper'

RSpec.describe SafePusher::RspecRunner do
  subject(:run_specs) { rspec_runner.call }

  let(:rspec_runner) { described_class.new }
end
