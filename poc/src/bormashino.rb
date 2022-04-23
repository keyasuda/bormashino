require 'rack'
# rubocop:disable Lint/Void
Rack::Response # workaround
# rubocop:enable Lint/Void
require 'json/pure'
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

    def self.request(method, path, payload = '')
      @app.call({
                  'HTTP_HOST' => 'example.com:0',
                  'REQUEST_METHOD' => method,
                  'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
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

    def self.put(path, payload)
      self.request('PUT', path, payload)
    end

    def self.patch(path, payload)
      self.request('PATCH', path, payload)
    end

    def self.delete(path, payload)
      self.request('DELETE', path, payload)
    end
  end

  module Utils
    def self.to_rb_value(escaped_json)
      JSON.parse(CGI.unescape(escaped_json))
    end
  end
end
