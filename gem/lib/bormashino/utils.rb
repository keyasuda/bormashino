require 'json/pure'
require 'cgi'

module Bormashino
  module Utils
    def self.to_rb_value(escaped_json)
      JSON.parse(CGI.unescape(escaped_json))
    end
  end
end
