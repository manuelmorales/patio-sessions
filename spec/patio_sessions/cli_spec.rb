require_relative '../spec_helper'

describe Cli do
  let(:cli){ Cli.new }

  describe '#test' do
    it 'runs the RSpec suite' do
      expect(RSpec::Core::Runner).to receive(:run)
      cli.test
    end

    it 'passes args to RSpec' do
      expect(RSpec::Core::Runner).to receive(:run).with(['random','args'])
      cli.test('random','args')
    end

    it 'passes ["spec"] if no args are specified' do
      expect(RSpec::Core::Runner).to receive(:run).with(['spec'])
      cli.test
    end
  end

  describe '#console' do
    it 'loads the environment and runs pry' do
      expect(Pry).to receive(:start)
      cli.console
    end
  end

  describe '#start' do
    it 'runs a Puma server' do
      expect_any_instance_of(Puma::CLI).to receive(:run)
      cli.start
    end
  end
end

