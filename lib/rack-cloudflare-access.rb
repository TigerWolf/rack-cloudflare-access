require "logger"

require "cloudflare_access/middleware"
require "cloudflare_access/version"
require "cloudflare_access/railtie" if defined?(::Rails::Railtie)

module Rack
  class CloudflareAccess
    class << self
      def logger
        @logger ||= defined?(Rails) ? Rails.logger : ::Logger.new($stdout)
      end

      attr_writer :logger
    end
  end
end
