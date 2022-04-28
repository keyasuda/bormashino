require 'js'

module JS
  class Object
    def to_rb
      JSON.parse(JS.global[:JSON].call(:stringify, self).inspect)
    end
  end
end
