require 'js'
require_relative 'ext/js'
require 'cgi'

module Bormashino
  # wrapper of Fetch API
  class Fetch
    attr_accessor :resource, :init, :resolved_to, :options

    def initialize(resource:, resolved_to:, init: {}, options: {})
      JS.eval("console.warn('Bormashino::Fetch is deprecated. Use Fetch API and JS::Object#await')")

      @resource = resource
      @init = init
      @resolved_to = resolved_to
      @options = options
    end

    def run
      raise 'No mounted apps' unless Bormashino::Server.mounted?

      # rubocop:disable Style::DocumentDynamicEvalDefinition
      JS.eval <<-ENDOFEVAL
        fetch(
          #{@resource.to_json},
          #{@init.to_json}
        ).then((r) => {
          r.text().then((t) => {
            window.bormashino.request(
              'post',
              #{@resolved_to.to_json},
              'status=' + r.status +
              '&payload=' + encodeURIComponent(t) +
              '&options=' + #{CGI.escape(@options.to_json).to_json}
            )
          })
        })
      ENDOFEVAL
      # rubocop:enable Style::DocumentDynamicEvalDefinition
    end
  end
end
