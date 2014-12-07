require_relative '../spec_helper'

RSpec.describe App do
  subject { app }
  let(:app) { App.new }

  describe 'actions' do
    describe 'sessions' do
      let(:actions) { subject.actions.sessions }

      describe 'show' do
        it 'is a SessionsController::Show' do
          expect(actions.show).to eq SessionsController::Show
        end

        it 'has resolves the sessions repo' do
          expect(actions.show.sessions_repo).to eq subject.repos.sessions

          new_repo = double('new_sessions_repo')
          subject.repos.sessions = new_repo
          expect(actions.show.sessions_repo).to eq new_repo
        end
      end
    end
  end


  describe 'repos' do
    describe 'sessions' do
      it 'has a sessions repo' do
        expect(subject.repos.sessions).to be_an_instance_of(SessionsMemoryRepo)
      end
    end
  end
end
