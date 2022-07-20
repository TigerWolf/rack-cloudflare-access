require "jwt"
require "net/http"
# require 'action_dispatch'

module Rack
  module CloudflareAccess
    class AuthError < StandardError; end

    class Middleware
      def initialize(app, teams_url, aud)
        @app = app
        @teams_url = teams_url
        @aud = aud
      end

      def call(env)
        token = get_token(env)

        if token.nil? || token.empty? # FIXME: We could use present? or blank? if we included activesupport
          return error("JWT Cookie not found")
        end

        payload = decode_token(token)

        email = payload["email"]
        return error("User #{email} not found") unless email

        env["jwt.email"] = email

        @app.call(env)
      end

      private

      def decode_token(token)
        jwk_loader = lambda do |options|
          @cached_keys = nil if options[:invalidate]
          @cached_keys ||= keys
        end

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
        payload
      end

      def get_token(env)
        request_cookies =
          if defined?(ActionDispatch::Request)
            ::ActionDispatch::Request.new(env).cookies
          else
            Rack::Utils.parse_cookies(env)
          end
        request_cookies["CF_Authorization"]
      end

      def cf_aud
        @aud
      end

      def cf_teams_url
        @teams_url
      end

      def keys
        uri = URI("#{cf_teams_url}/cdn-cgi/access/certs")
        JSON.parse(Net::HTTP.get(uri)) # .deep_symbolize_keys!
      end

      def error(message)
        Rack::CloudflareAccess.logger.error message
        raise AuthError, message
      end
    end
  end
end
