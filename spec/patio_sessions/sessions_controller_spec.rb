require_relative '../rack_spec_helper'

describe SessionsController do
  let(:app){ RackApp }

  context 'GET /sessions/:id' do
    context 'successful' do
      let(:path) { "/sessions/#{session_id}" }
      let(:session_id) { 'a-session-id' }

      def do_request
        get path, {}, 'HTTP_ACCEPT' => 'application/json'
      end

      it 'works setting the extension in the path' do
        get path + '.json'
        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq('application/json')
      end

      it 'returns status 200' do
        do_request
        expect(last_response.status).to eq 200
      end

      it 'returns valid JSON' do
        do_request
        expect(last_response.content_type).to eq('application/json')
        JSON.parse(last_response.body)
      end
    end
  end
end
