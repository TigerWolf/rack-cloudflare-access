# frozen_string_literal: true

require "spec_helper"
require "open3"
require "stringio"
require "support/mock_rack_app"

RSpec.describe "when used as middleware", type: :request do
  let(:teams_url) { "http://cloudflare.teamurl.com" }
  let(:aud) { "1516239022" }
  let(:app) do
    local_teams_url = teams_url
    local_aud = aud
    Rack::Builder.new do
      use Rack::CloudflareAccess::Middleware, local_teams_url, local_aud
      run lambda { |env|
        if env["PATH_INFO"] == "/home"
          [200, {}, ["Hello, World"]]
        else
          [404, {}, ["Goodbye, World"]]
        end
      }
    end
  end

  context "no JWT cookie is set" do
    it "returns an AuthError" do
      expect { get "/home" }.to raise_error(Rack::CloudflareAccess::AuthError)
    end
  end

  context "when is a cookie is set but token is invalid" do
    before do
      set_cookie "CF_Authorization=aaaa"
    end
    it "returns a JWT DecodeError" do
      expect { get "/home" }.to raise_error(JWT::DecodeError)
    end
  end

  context "with a valid JWT token and JWK" do
    let(:jwt_teams_url) { "https://my-rack-app.cloudflareaccess.com" }
    let(:jwt_aud) { "83a9f5be00d3aab8cea92a4b348120aafa800b2bfbcf18e68a2b22995b7d68e4" }
    let(:app) { MockRackApp.new }
    let(:middleware) { Rack::CloudflareAccess::Middleware.new(app, teams_url, aud) }
    let(:env) { Rack::MockRequest.env_for("/index") }

    let(:jwk) do
      JWT::JWK.new(OpenSSL::PKey::RSA.new(2048), "fe08dc74af21deacd012358bb64fccb79081a43903d78ce54e10748fcce8c812")
    end

    # This is what finds the certificate - so we can match it up with the fake respose
    let(:jwt_headers) do
      { kid: jwk.kid }
    end

    let(:jwt_payload) do
      { email: "test@example.com", aud: jwt_aud,
        iss: jwt_teams_url }
    end

    let(:jwt_token) { JWT.encode jwt_payload, jwk.keypair, "RS256", jwt_headers }

    before do
      env["HTTP_COOKIE"] = "CF_Authorization=#{jwt_token}"
      allow(middleware).to receive(:keys).and_return({ keys: [jwk.export] })
    end

    context "aud is the same as that in the token" do
      let(:aud) { "adada" }
      let(:teams_url) { jwt_teams_url }
      it "raises invalid aud error" do
        expect do
          middleware.call(env)
        end.to raise_error(JWT::InvalidAudError, "Invalid audience. Expected #{aud}, received #{jwt_aud}")
      end
    end

    context "teams url is not the same as in the token" do
      let(:aud) { jwt_aud }
      let(:teams_url) { "http://anotherexample.com" }
      it "raises invalid teams url error" do
        expect do
          middleware.call(env)
        end.to raise_error(JWT::InvalidIssuerError, "Invalid issuer. Expected #{teams_url}, received #{jwt_teams_url}")
      end
    end

    context "aud and teams url are valid" do
      let(:aud) { jwt_aud }
      let(:teams_url) { jwt_teams_url }
      it "validates the JWT and saves the email in the rack env" do
        middleware.call(env)
        expect(app["jwt.email"]).to eq("test@example.com")
      end
    end
  end
end
