lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloudflare_access/version"

Gem::Specification.new do |spec|
  spec.name = "rack-cloudflare-access"
  spec.version = Rack::CloudflareAccess::VERSION
  spec.authors = ["Kieran"]
  spec.email = ["TigerWolf@users.noreply.github.com"]

  spec.summary = "Add SSO to your application with this Rack Middleware to add Cloudflare Access
   to your Rack or Rails application"
  spec.description = "Add SSO to your application with this Rack Middleware to add
  Cloudflare Access to your Rack or Rails application"
  spec.homepage = "https://github.com/TigerWolf/rack-cloudflare-access"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/TigerWolf/rack-cloudflare-access"
  spec.metadata["changelog_uri"] = "https://github.com/TigerWolf/rack-cloudflare-access/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "jwt", "~> 2.3.0"
  # spec.add_dependency "activesupport"
  # spec.add_dependency "rails" # Can we make this optional?

  spec.add_development_dependency("pry")
  spec.add_development_dependency("rack-test", "~> 2.0.2")
  spec.add_development_dependency("rspec", "~> 3.11.0")

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
