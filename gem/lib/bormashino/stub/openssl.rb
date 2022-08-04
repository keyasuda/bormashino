require 'digest/sha2'

module OpenSSL
  # stub module which won't work on ruby.wasm
  module Digest
    class SHA1; end
    class SHA256; end
  end

  # stub module which won't work on ruby.wasm
  module HMAC
    def self.hexdigest(_, secret, data)
      Digest::SHA2.hexdigest("#{secret}#{data}")
    end
  end
end
