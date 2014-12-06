require_relative '../spec_helper'

RSpec.describe App do
  subject { app }
  let(:app) { App.new }

  it 'has a sessions show action' do
    expect(subject.actions.sessions.show).to eq SessionsController::Show
    expect(subject.actions.sessions.show.sessions_repo).to be_an_instance_of(SessionsMemoryRepo)
  end

  it 'has a sessions repo' do
    expect(subject.repos.sessions).to be_an_instance_of(SessionsMemoryRepo)
  end
end
