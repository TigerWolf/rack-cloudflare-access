module Rack::CloudflareAccess
  class Railtie < ::Rails::Railtie
    config.action_dispatch.rescue_responses.merge!(
      'CloudflareAccess::AuthError' => :unauthorized
    )

    ## Future Improvement opportunity?
    # initializer "cloudflare_access.configure_rails_initialization" do
    #   Rails.application.middleware.use Rack::CloudflareAccess::Middleware # Do we want this to be automatic?
    # end
  end
end
