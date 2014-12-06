require_relative '../rack_spec_helper'

describe SessionsController do
  context 'Show' do
    let(:path) { "/sessions/#{session_id}" }
    let(:session_id) { 'a-session-id' }
    let(:session) { Session.new id: session_id }
    let(:sessions_repo) { SessionsMemoryRepo.new }

    before do
      SessionsController::Show.sessions_repo = sessions_repo
      sessions_repo.save session
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

      it 'creates new instances for each request for thread safety' do
        instances = []

        allow_any_instance_of(SessionsController::Show).to receive(:call) do |action, env|
          instances << action
          [200, {}, []]
        end

        do_request
        do_request

        expect(instances.length).to eq 2
        expect(instances.first).not_to eq instances.last
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
