module Zlib
  # stub module which won't work on ruby.wasm
  module Deflate
    def self.deflate(src)
      src
    end
  end

  # stub module which won't work on ruby.wasm
  module Inflate
    def self.inflate(src)
      src
    end
  end
end
