# frozen_string_literal: true

require_relative "rack/cloudflare_access/version"
require "rack/cloudflare_access/railtie" if defined?(::Rails::Railtie)
require "rack/cloudflare_access/middleware"
require "logger"
# require 'active_support/core_ext/object/blank' # Might be able to get away with not using it

# Usage: Rails.application.config.middleware.use(Rack::CloudflareAccess::Middleware, aud, teams_url)

module Rack
  module CloudflareAccess
    class << self
      def logger
        @logger ||= defined?(Rails) ? Rails.logger : ::Logger.new($stdout)
      end

      attr_writer :logger
    end
  end
end
