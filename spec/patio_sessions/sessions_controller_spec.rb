require_relative '../rack_spec_helper'

describe SessionsController do
  context 'Show' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session_id) { 'a-session-id' }
    let(:session) { double('session', id: session_id) }
    let(:sessions_repo) { double('sessions_repo', find: session) }

    before do
      allow(subject).to receive(:sessions_repo).and_return(sessions_repo)
    end

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


      context 'successful' do
        it 'returns status 200' do
          do_request
          expect(last_response.status).to eq 200
        end

        it 'renders the session from the session repository' do
          do_request
          expect(JSON.parse last_response.body).to eq('id' => session_id)
        end
      end
    end
  end
end
