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

  describe 'AppBase' do
    let(:subject_class) { AppBase }

    describe 'let' do
      it 'provides a getter and setter' do
        app = subject_class.new
        app.let(:counter) { 3 }
        expect(app.counter).to eq 3
      end

      it 'layzy evaluates' do
        builder = double('builder')
        app = subject_class.new
        app.let(:counter) { builder.build }

        allow(builder).to receive(:build)
        app.counter
      end

      it 'memoizes even when the returned value is nil' do
        builder = double('builder', build: nil)
        app = subject_class.new
        app.let(:counter) { builder.build }

        allow(builder).to receive(:build).once
        app.counter
        app.counter
      end
    end

    describe 'section' do
      it 'gives the another section app base' do
        app = subject_class.new
        app.section(:counters) { 3 }
        expect(app.counters).to be_a(subject_class)
      end
    end  
  end
end
