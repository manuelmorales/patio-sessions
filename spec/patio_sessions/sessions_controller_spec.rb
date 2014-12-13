require_relative '../rack_spec_helper'

describe SessionsController do
  context 'Show' do
    let(:app){ patio_app.rack }
    let(:patio_app) { App.new }

    let(:path) { "/sessions/#{session_id}" }
    let(:action) { patio_app.actions.sessions.show }

    let(:session) { Session.new id: session_id }
    let(:session_id) { 'a-session-id' }

    before do
      action.sessions_repo.save session
    end

    context 'Rack integration' do
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

      context 'not found' do
        let(:path) { '/sessions/INVALID-id' }

        it 'returns status 404' do
          do_request
          expect(last_response.status).to eq 404
        end

        it 'renders the error' do
          do_request
          expect(JSON.parse last_response.body).to eq({
            'error_code' => "not_found",
            'error_message' => "Could not find session with id INVALID-id",
          })
        end
      end
    end
  end

  context 'Update' do
    let(:app){ patio_app.rack }
    let(:patio_app) { App.new }

    let(:path) { "/sessions/#{session_id}" }
    let(:action) { patio_app.actions.sessions.update }

    let(:session_id) { 'a-session-id' }

    def do_request
      put path, {}, 'HTTP_ACCEPT' => 'application/json'
    end


    it 'creates new instances for each request for thread safety' do
      instances = []

      allow_any_instance_of(SessionsController::Update).to receive(:call) do |action, env|
        instances << action
        [200, {}, []]
      end

      do_request
      do_request

      expect(instances.length).to eq 2
      expect(instances.first).not_to eq instances.last
    end

    it 'is a new instance for each app' do
      expect(App.new.actions.sessions.update).not_to eq App.new.actions.sessions.update
    end

    context 'successful' do
      it 'returns status 200' do
        do_request
        expect(last_response.status).to eq 200
      end

      it 'has no body' do
        do_request
        expect(last_response.body).to eq ''
        expect(last_response.content_type).to be_nil
      end

      it 'stores a new session in the repo' do
        expect(action.sessions_repo).to receive(:save) do |session|
          expect(session.id).to eq session_id
        end

        do_request
      end
    end
  end
end
