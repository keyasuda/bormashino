require 'rack'
# rubocop:disable Lint/Void
Rack::Response # workaround
# rubocop:enable Lint/Void
require 'stringio'
require_relative 'app'

module Bormashino
  module Server
    def self.mount(app_class)
      @app = app_class.new
    end

    def self.request(method, path, payload = '')
      @app.call({
                  'HTTP_HOST' => 'example.com:0',
                  'REQUEST_METHOD' => method,
                  'QUERY_STRING' => '',
                  'PATH_INFO' => path,
                  'rack.input' => StringIO.new(payload),
                  'rack.errors' => StringIO.new(''),
                }).to_json
    end

    def self.get(path)
      self.request('GET', path)
    end

    def self.post(path, payload)
      self.request('POST', path, payload)
    end
  end

  module Client
  end
end

Bormashino::Server.mount(App)
