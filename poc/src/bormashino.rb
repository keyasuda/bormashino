require 'rack'
# rubocop:disable Lint/Void
Rack::Response # workaround
# rubocop:enable Lint/Void
require 'json/pure'
require 'cgi'
require 'js'
require 'singleton'
require 'stringio'

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

  module Utils
    def self.to_rb_value(escaped_json)
      JSON.parse(CGI.unescape(escaped_json))
    end
  end

  class LocalStorage
    include Singleton

    def initialize
      @storage = JS.global[:localStorage]
    end

    def length
      @storage[:length].to_rb
    end

    def key(index)
      @storage.call(:key, index).to_rb
    end

    def get_item(key_name)
      @storage.call(:getItem, key_name).to_rb
    end

    def set_item(key_name, key_value)
      @storage.call(:setItem, key_name, key_value)
    end

    def remove_item(key_name)
      @storage.call(:removeItem, key_name)
    end

    def clear
      @storage.call(:clear)
    end
  end

  class SessionStorage < LocalStorage
    def initialize
      super
      @storage = JS.global[:sessionStorage]
    end
  end
end
