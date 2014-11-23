require 'json'

module PatioSessions
  class RackApp
    def self.call env
      # get '/admin/info' do
      headers = { 'Content-Type' => 'application/json' }
      body = {
        :name => 'PatioSessions',
        :version => VERSION,
      }.to_json
      status = 200
      [status, headers, [body]]
    end
  end
end

