require_relative '../rack_spec_helper'

describe 'RackApp' do
  let(:app){ RackApp }

  it 'returns 404 for unknown paths' do
    get '/dasadsadda'
    expect(last_response.status).to eq 404
  end

  it 'routes /sessions/:id' do
    path = "/sessions/a-session-id"

    action = app.instance_variable_get(:@router).routes.map(&:dest).detect{|a| a.is_a?(Lotus::Routing::Endpoint) && a.__getobj__.is_a?(SessionsController::Show) }
    action = app.instance_variable_get(:@router).recognize(Rack::MockRequest.env_for(path, method: 'GET')).first.first.route.dest
    expect(action).to eq(action)

    expect(action).to receive(:call) do |env|
      expect(env['router.params']).to eq(id: 'a-session-id')
      [200, {}, []]
    end

    get path, {}, 'HTTP_ACCEPT' => 'application/json'
  end
end
