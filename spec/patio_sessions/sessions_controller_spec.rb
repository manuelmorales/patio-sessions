require_relative '../rack_spec_helper'

describe SessionsController do
  context 'Show' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session_id) { 'a-session-id' }

    context 'Rack integration' do
      let(:app){ RackApp }

      def do_request
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

    context 'successful' do
      subject{ SessionsController::Show.new }

      def rack_response response
        Rack::Response.new response[2], response[0], response[1]
      end

      def body response
        JSON.parse rack_response(response).body.join
      end

      def status response
        rack_response(response).status
      end

      def headers response
        rack_response(response).headers
      end

      def header name, response
        headers(response)[name]
      end

      it 'returns status 200' do
        response = subject.call(id: session_id)
        expect(status response).to eq 200
      end

      it 'returns valid JSON' do
        response = subject.call(id: session_id)
        expect(header 'Content-Type', response).to eq 'application/json'
        expect(body response).to eq({})
      end
    end
  end
end
