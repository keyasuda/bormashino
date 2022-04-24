require 'rack'
# rubocop:disable Lint/Void
Rack::Response # workaround
# rubocop:enable Lint/Void
require 'json/pure'
require 'uri'
require 'cgi'
require 'js'
require 'singleton'
require 'stringio'

require_relative 'storage'

module JS
  class Object
    def to_rb
      JSON.parse(JS.global[:JSON].call(:stringify, self).inspect)
    end
  end
end

module Bormashino
  module Server
    def self.mount(app_class)
      @app = app_class.new
    end

    def self.request(method, target, payload = '', referer = '')
      u = URI(target)

      @app.call({
                  'HTTP_HOST' => 'example.com:0',
                  'REQUEST_METHOD' => method,
                  'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                  'QUERY_STRING' => u.query,
                  'PATH_INFO' => u.path,
                  'HTTP_REFERER' => referer,
                  'rack.input' => StringIO.new(payload),
                  'rack.errors' => StringIO.new(''),
                }).to_json
    end
  end

  module Utils
    def self.to_rb_value(escaped_json)
      JSON.parse(CGI.unescape(escaped_json))
    end
  end
end
