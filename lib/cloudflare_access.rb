require_relative "rack/cloudflare_access/version"
require "rack/cloudflare_access/railtie" if defined?(::Rails::Railtie)
require "rack/cloudflare_access/middleware"
require "logger"

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
