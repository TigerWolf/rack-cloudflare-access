# frozen_string_literal: true

require_relative "rack/cloudflare_access/version"
require "rack/cloudflare_access/railtie" if defined?(::Rails::Railtie)
require "rack/cloudflare_access/middleware"
require 'logger'
# require 'active_support/core_ext/object/blank' # Might be able to get away with not using it

# Usage: Rails.application.config.middleware.use(Rack::CloudflareAccess::Middleware)

module Rack
  module CloudflareAccess
    class << self

      # The Cloudflare Teams url
      attr_accessor :teams_url
      # The Audience claim
      attr_accessor :aud

      def logger
        @@logger ||= defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT)
      end
    
      def logger=(logger)
        @@logger = logger
      end

    end
  end
end
