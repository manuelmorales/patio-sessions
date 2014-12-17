require_relative '../rack_spec_helper'

describe 'integration' do
  def patio_app
    integration_app
  end

  let(:app){ patio_app.rack }

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session) { Session.new id: session_id }
    let(:session_id) { 'a-session-id' }

    before do
      patio_app.repos.sessions.save session
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
