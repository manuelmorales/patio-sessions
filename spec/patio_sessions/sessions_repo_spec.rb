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

  it 'save() and find() by id' do
    session = Session.new id: 'session-id', content: { user_id: 'user-id' }
    expect{ subject.find('session-id') }.to raise_exception

    subject.save session
    result = subject.find 'session-id'

    expect(result.id).to eq 'session-id'
    expect(result.content[:user_id]).to eq 'user-id'
  end

  describe 'with redis store' do
    let(:redis_store) { {} }
    let(:subject) do
      patio_app.repos.sessions.tap do |r|
        r.store = Inline.new do
          cattr_injectable :redis

          redis { Lazy.new { Redis.new } }

          def [] key
            result = redis.get key
            Marshal.load result if result
          end

          def []= key, value
            redis.set key, Marshal.dump(value)
          end
        end
      end
    end

    before :each do
      require 'redis'
      Redis.new.flushdb
    end

    it 'save() and find() by id' do
      session = Session.new id: 'session-id', content: { user_id: 'user-id' }
      expect{ subject.find('session-id') }.to raise_exception

      subject.save session
      result = subject.find 'session-id'

      expect(result.id).to eq 'session-id'
      expect(result.content[:user_id]).to eq 'user-id'
    end
  end
end
