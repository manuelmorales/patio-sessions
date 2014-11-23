require_relative '../rack_spec_helper'

describe 'RackApp' do
  let(:app){ RackApp }

  it 'returns 404 for unknown paths' do
    get '/dasadsadda'
    expect(last_response.status).to eq 404
  end

  it 'routes /sessions/:id' do
    path = "/sessions/a-session-id"

    action = app.recognize :get, path

    expect(action).to receive(:call) do |env|
      expect(env['router.params']).to eq(id: 'a-session-id')
      [200, {}, []]
    end

    get path, {}, 'HTTP_ACCEPT' => 'application/json'
  end
end
