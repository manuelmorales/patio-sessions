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

      def response value = nil
        @response ||= value
      end

      def rack_response response = @response
        Rack::Response.new response[2], response[0], response[1]
      end

      def body response = @response
        JSON.parse rack_response(response).body.join, :symbolize_names => true
      end

      def status response = @response
        rack_response(response).status
      end

      def headers response = @response
        rack_response(response).headers
      end

      def header name, response = @response
        headers(response)[name]
      end

      it 'returns status 200' do
        response subject.call('router.params' => {id: session_id})
        expect(status).to eq 200
      end

      it 'returns valid JSON' do
        response subject.call('router.params' => {id: session_id})
        expect(header 'Content-Type').to eq 'application/json'
        expect(body).to be_a Hash
      end

      let(:session) { double('session', id: session_id) }
      let(:sessions_repo) { double('sessions_repo', find: session) }
      before do
        allow(subject).to receive(:sessions_repo).and_return(sessions_repo)
      end

      it 'gets the session from the session repository' do
        response subject.call('router.params' => {id: session_id})
        expect(body).to eq(id: session_id)
      end
    end
  end
end
