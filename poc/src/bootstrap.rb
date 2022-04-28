require 'bormashino'
require 'bormashino/local_storage'

require_relative 'app'

Bormashino::Server.mount(App)
