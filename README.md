# Rack::CloudflareAccess

This is a rack middleware to add Cloudflare access to your application. https://developers.cloudflare.com/cloudflare-one/ 
## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rack-cloudflare-access

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rack-cloudflare-access

## Usage

You will need to configure the team url and aud from Cloudflare. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TigerWolf/rack-cloudflare-access. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/TigerWolf/rack-cloudflare-access/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rack::Cloudflare::Access project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/TigerWolf/rack-cloudflare-access/blob/master/CODE_OF_CONDUCT.md).


# TODO

* Best way configure AUD and Team url - is this going to be when calling the middleware or configuration in the main file
* Mock out all web requests to Cloudflare (teams url etc)
* Create JWT cookie on the fly in tests

Version 2
* Allow for urls to be filtered out (e.g. login)
* More efficient HTTP library for getting the certs - for now just keep it simple
* possibly better rails integration? .present? and deep_symbolize_keys! could use quite useful
