require_relative '../rack_spec_helper'

describe RackApp do
  let(:app){ RackApp }
  let(:host){ 'http://example.org' }

  it 'returns 404 for unknown paths' do
    get '/dasadsadda'
    expect(last_response.status).to eq 404
  end
end
