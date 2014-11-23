require 'json'
require 'lotus/router'

module PatioSessions
  class RackInfo
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

  RackApp = Lotus::Router.new do
    get '/admin/info', to: RackInfo
  end
end

