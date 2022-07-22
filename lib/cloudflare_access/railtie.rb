module Rack
  class CloudflareAccess
    class Railtie < ::Rails::Railtie
      config.action_dispatch.rescue_responses.merge!(
        "Rack::CloudflareAccess::AuthError" => :unauthorized
      )

      ## Future Improvement opportunity
      # initializer "cloudflare_access.configure_rails_initialization" do
      #   Rails.application.middleware.use Rack::CloudflareAccess::Middleware
      # end
    end
  end
end
