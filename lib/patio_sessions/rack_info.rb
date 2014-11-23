require 'json'

module PatioSessions
  class RackInfo
    def self.call env
      status = 200

      body = {
        :name => 'PatioSessions',
        :version => VERSION,
      }.to_json

      headers = { 'Content-Type' => 'application/json' }

      [status, headers, [body]]
    end
  end
end

