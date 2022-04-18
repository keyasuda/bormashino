require 'digest/sha2'

module OpenSSL
  module Digest
    class SHA1; end
    class SHA256; end
  end

  module HMAC
    def self.hexdigest(_, secret, data)
      Digest::SHA2.hexdigest("#{secret}#{data}")
    end
  end
end
