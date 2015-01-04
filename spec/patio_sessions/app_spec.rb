require_relative '../spec_helper'

RSpec.describe App do
  subject { app }
  let(:app) { App.new }

  describe 'actions' do
    describe 'sessions' do
      let(:actions) { subject.actions.sessions }

      describe 'show' do
        it 'resolves the sessions repo' do
          expect(actions.show.sessions_repo).to eq subject.repos.sessions

          new_repo = double('new_sessions_repo')
          subject.repos.tool(:sessions) { new_repo }
          expect(actions.show.sessions_repo).to eq new_repo
        end
      end
    end
  end
end
