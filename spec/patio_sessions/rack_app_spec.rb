require_relative '../rack_spec_helper'

describe 'rack' do
  let(:app){ patio_app.rack }

  it 'returns 404 for unknown paths' do
    get '/dasadsadda'
    expect(last_response.status).to eq 404
  end

  describe 'GET /sessions/:id' do
    let(:path) { "/sessions/#{session_id}" }
    let(:action) { patio_app.actions.sessions.show }

    let(:session) { Session.new id: session_id }
    let(:session_id) { 'a-session-id' }

    before do
      action.sessions_repo.save session
    end

    it 'calls app.actions.sessions.show' do
      expect(patio_app.actions.sessions.show).to receive(:call).and_return([200, {}, []])
      get path

      new_action = double('action')
      patio_app.actions.sessions.tool(:show) { new_action }
      expect(new_action).to receive(:call).and_return([200, {}, []])
      get path
    end

    it 'routes /sessions/:id' do
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
