require 'uri'
require 'stringio'

module Bormashino
  # pseudo rack server module
  module Server
    def self.mounted?
      !@app.nil?
    end

    def self.mount(app_class)
      @app = app_class.new
    end

    def self.request(method, target, payload = '', referer = '')
      u = URI(target)

      @app.call({
                  'HTTP_HOST' => 'example.com:0',
                  'REQUEST_METHOD' => method.upcase,
                  'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                  'QUERY_STRING' => u.query,
                  'PATH_INFO' => u.path,
                  'HTTP_REFERER' => referer,
                  'rack.input' => StringIO.new(payload),
                  'rack.errors' => StringIO.new(''),
                }).to_json
    end
  end
end
