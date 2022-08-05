require 'singleton'

module Bormashino
  # LocalStorage mock for unit tests
  class LocalStorage
    include Singleton
    attr_reader :store

    def initialize
      @store = {}
    end

    def length
      @store.size
    end

    def key(index)
      @store.keys[index]
    end

    def get_item(key_name)
      @store[key_name]
    end

    def set_item(key_name, key_value)
      @store[key_name] = key_value
    end

    def remove_item(key_name)
      @store.delete(key_name)
    end

    def clear
      @store.clear
    end
  end
end
