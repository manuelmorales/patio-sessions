require_relative '../rack_spec_helper'

describe 'integration' do
  def patio_app
    integration_app
  end

  let(:app){ patio_app.rack }

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session_id) { 'a-session-id' }

    def do_get
      get path, {}, 'HTTP_ACCEPT' => 'application/json'
    end

    def do_put
      put path, {user_id: 37}.to_json, 'HTTP_ACCEPT' => 'application/json', 'Conten-Type' => 'application/json'
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
      expect(body).to eq id: session_id, content: {user_id: 37}
    end
  end
end
