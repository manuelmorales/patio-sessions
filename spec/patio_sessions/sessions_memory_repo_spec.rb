require_relative '../spec_helper'

RSpec.describe SessionsMemoryRepo do
  subject { repo }
  let(:repo) { SessionsMemoryRepo.new }
  let(:session) { Session.new }

  it 'can store and retrieve sessions by id' do
    subject.save session
    expect(subject.find(session.id)).to eq session
  end
end
