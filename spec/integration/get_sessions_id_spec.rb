require_relative '../rack_spec_helper'

describe 'integration' do
  let(:app){ RackApp }

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }

    let(:sessions_repo) do 
      SessionsMemoryRepo.new.tap do |r|
        r.save session
      end
    end

    let(:session) { Session.new id: session_id }
    let(:session_id) { 'a-session-id' }

    before do
      SessionsController::Show.sessions_repo = sessions_repo
    end

    def do_request
      get path, {}, 'HTTP_ACCEPT' => 'application/json'
    end

    it 'returns a session' do
      do_request

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq('application/json')

      body = JSON.parse(last_response.body)
      expect(body).to be_a Hash
    end
  end
end
