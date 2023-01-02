require 'js'

module JS
  # extends ruby.wasm JS::Object to intract with JS
  class Object
    def to_rb
      JSON.parse(JS.global[:JSON].call(:stringify, self).to_s)
    end
  end
end
