require 'js'
require_relative 'ext/js'

module Bormashino
  class Fetch
    attr_accessor :resource, :init, :resolved_to

    def initialize(resource:, resolved_to:, init: {})
      @resource = resource
      @init = init
      @resolved_to = resolved_to
    end

    def run
      raise 'No app is mounted' unless Bormashino::Server.mounted?

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
              '&payload=' + encodeURIComponent(t)
            )
          })
        })
      ENDOFEVAL
      # rubocop:enable Style::DocumentDynamicEvalDefinition
    end
  end
end
