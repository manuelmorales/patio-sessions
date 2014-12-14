require_relative '../spec_helper'

RSpec.describe SessionsRepo do
  def subject
    patio_app.repos.sessions
  end

  let(:patio_app) { App.new }
  let(:session) { Session.new }

  describe '#find(id)' do
    it 'returns the session with such id' do
      subject.save session
      expect(subject.find(session.id)).to eq session
    end

    it 'raises an exception when not found' do
      expect{ subject.find(99) }.to raise_exception do |e|
        expect(e.message).to eq 'Could not find session 99'
      end
    end
  end
end
