require_relative '../rack_spec_helper'

describe 'integration' do
  let(:app){ patio_app.rack }
  let(:patio_app) { App.new }

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session) { Session.new id: session_id }
    let(:session_id) { 'a-session-id' }

    def do_get
      get path, {}, 'HTTP_ACCEPT' => 'application/json'
    end

    def do_put
      put path, {}, 'HTTP_ACCEPT' => 'application/json'
    end

    it 'returns a session' do
      do_get
      expect(last_response.status).to eq 404

      do_put
      expect(last_response.status).to eq 200

      do_get
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq('application/json')

      body = JSON.parse(last_response.body, symbolize_names: true)
      expect(body).to eq id: session_id
    end
  end
end
