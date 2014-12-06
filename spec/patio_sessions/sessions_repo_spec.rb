require_relative '../spec_helper'

RSpec.describe SessionsRepo do
  subject { repo }
  let(:repo) { SessionsRepo.new }
  let(:session) { Session.new }

  it 'can store and retrieve sessions by id' do
    subject.save session
    expect(subject.find(session.id)).to eq session
  end
end
