[![Build Status](https://travis-ci.com/williampollet/safe_pusher.svg?branch=master)](https://travis-ci.com/williampollet/safe_pusher)
[![Maintainability](https://api.codeclimate.com/v1/badges/1aa6c275f9ce4d4c6ec3/maintainability)](https://codeclimate.com/github/williampollet/safe_pusher/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1aa6c275f9ce4d4c6ec3/test_coverage)](https://codeclimate.com/github/williampollet/safe_pusher/test_coverage)

# SafePusher

Run your favorite linters and specs on the files you touched, before pushing your branch.

## Installation

Add these lines to your application's Gemfile:

```ruby
# Lint and launch specs before pushing.
gem 'safe_pusher', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe_pusher

To use the gem fully, you should install [pronto](https://github.com/prontolabs/pronto) and [rspec](https://github.com/rspec/rspec) first.

## Configuration

Generate the `binstubs` for `pronto`, `rspec` and `safepush`:

    $ bundler binstubs pronto rspec-core safe_pusher

Create the `safe_pusher.yml` file at the root of your application:

```yaml
files_to_skip:
  - file/to/skip_1
  - file/to/skip/2
app_base_directory: app
repo_url: https://github.com/williampollet/safe_pusher
```

## Usage

To see the commands available, type:

    $ safepush

To run pronto checks before you push to GitHub run:

    $ safepush lint push open

or

    $ safepush l p o

To run specs and pronto before you push to GitHub run:

    $ safepush test lint push open

or

    $ safepush t l p o

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/williampollet/safe_pusher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafePusher project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_pusher/blob/master/CODE_OF_CONDUCT.md).
