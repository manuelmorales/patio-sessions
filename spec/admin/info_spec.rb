require_relative '../rack_spec_helper'

RSpec.describe '/admin/info' do
  let(:app){ PatioSessions::RackApp }
  let(:path){ '/admin/info' }
  let(:parsed_response){ JSON.parse(last_response.body) }

  it 'is successful' do
    get path
    expect(last_response.status).to eq(200)
  end

  it 'returns valid JSON' do
    get path
    expect(last_response.content_type).to eq('application/json')
    JSON.parse(last_response.body)
  end

  it 'returns the name' do
    get path
    expect(parsed_response['name']).to eq('PatioSessions')
  end

  it 'returns the version number' do
    get path
    expect(parsed_response['version']).to eq(PatioSessions::VERSION)
  end
end

