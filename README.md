# google-sheet-api
A pure Ruby Google Sheet API for reading and writing to Google Sheets. Uses Google Forms for submitting data.
This is an unofficial project!

The aim is to create a client that uses pure Ruby to interact with a Google Sheet.

To read from the Google sheet it needs to be public.
To write to the Google sheet, you need to create a public Google form which submits to a Google sheet.

This is highly experimental and not really intended for production

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google-sheet-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google-sheet-api

## Usage

```ruby
  require 'google-sheet-api'
  client  = GoogleSheetApi::Client.new
```

### Endpoints
- `client.get_sheet_data(sheet_url, type: 'csv')`
- `client.get_form(form_url)`
- `client.get_form_inputs(form_url)`
- `client.get_post_form_url(form_url)`
- `client.submit_form(form_url, form_post_url, payload_object:)`
Make sure that the payload_object is a hash where the keys match the exact (human readable) names of the inputs as named on the form

### Constants
  Constants

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Tests
To run tests execute:

    $ rake test

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trex22/google-sheet-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the google-sheet-api: project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/trex22/google-sheet-api/blob/master/CODE_OF_CONDUCT.md).
