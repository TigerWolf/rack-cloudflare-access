require "jwt"
require "net/http"
# require 'action_dispatch'

module Rack::CloudflareAccess
  class AuthError < StandardError; end

  class Middleware
    def initialize(app, teams_url, aud)
      @app = app
      @teams_url = teams_url
      @aud = aud
    end

    def call(env)
      verify_token(env)
    end

    def verify_token(env)
      request_cookies =
        if defined?(ActionDispatch::Request)
          ::ActionDispatch::Request.new(env).cookies
        else
          Rack::Utils.parse_cookies(env)
        end
      token = request_cookies["CF_Authorization"]

      if token.nil? || token.empty? # FIXME: We could use present? or blank? if we included activesupport
        Rack::CloudflareAccess.logger.info("JWT Cookie not found")
        return return_error("JWT Cookie not found")
      end

      jwk_loader = lambda do |options|
        @cached_keys = nil if options[:invalidate]
        @cached_keys ||= keys
      end

      # require "pry"
      # binding.pry
      payload, = JWT.decode(
        token, nil, true, {
          nbf_leeway: 30,
          exp_leeway: 30,
          iss: cf_teams_url,
          verify_iss: true,
          aud: cf_aud,
          verify_aud: true,
          verify_iat: true,
          algorithm: "RS256",
          jwks: jwk_loader
        }
      )

      email = payload["email"]

      unless email
        error = "User #{email} not found"
        Rack::CloudflareAccess.logger.info(error)
        return return_error(error)
      end

      env["jwt.email"] = email

      @app.call(env)
    end

    private

    def cf_aud
      # "83a9f5be00d3aab8cea92a4b348120aafa800b2bfbcf18e68a2b22995b7d68e4"
      # ENV["CF_JWT_AUD"]
      # Rails.application.secrets.CF_JWT_AUD || ENV['CF_JWT_AUD']
      @aud
    end

    def cf_teams_url
      # "https://rack-tester.cloudflareaccess.com"
      # ENV["CF_TEAMS_URL"]
      # Rails.application.secrets.CF_TEAMS_URL || ENV['CF_TEAMS_URL']
      @teams_url
    end

    def keys
      uri = URI("#{cf_teams_url}/cdn-cgi/access/certs")
      JSON.parse(Net::HTTP.get(uri)) # .deep_symbolize_keys!
    end

    def return_error(message)
      raise AuthError, message
    end
  end
end
