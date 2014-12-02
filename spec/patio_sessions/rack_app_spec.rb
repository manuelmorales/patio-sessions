require_relative '../rack_spec_helper'

describe 'RackApp' do
  let(:app){ RackApp }

  it 'returns 404 for unknown paths' do
    get '/dasadsadda'
    expect(last_response.status).to eq 404
  end

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session_id) { 'a-session-id' }

    it 'routes /sessions/:id' do
      action = app.recognize :get, path

      expect(action).to receive(:call) do |env|
        expect(env['router.params']).to eq(id: 'a-session-id')
        [200, {}, []]
      end

      get path, {}, 'HTTP_ACCEPT' => 'application/json'
    end

    it 'works setting the extension in the path' do
      get path + '.json'
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq('application/json')
    end

    it 'works with the naked path' do
      get path
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq('application/json')
    end
  end
end
