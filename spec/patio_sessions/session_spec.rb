require_relative '../spec_helper'

RSpec.describe Session do
  subject { session }
  let(:session) { Session.new }

  it 'is a value object' do
    session_1 = Session.new id: 1
    session_1_copy = Session.new id: 1
    session_2 = Session.new id: 2

    expect(session_1).to eq session_1_copy
    expect(session_1).not_to eq session_2
  end

  it 'its content defaults to {}' do
    session = Session.new
    expect(session.content).to eq({})

    session.content = {x: 'y'}
    expect(session.content).to eq({x: 'y'})
  end
end
