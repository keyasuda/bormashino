require 'js'
require 'singleton'
require_relative 'ext/js'

module Bormashino
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
