[![Build Status](https://travis-ci.com/williampollet/safe_pusher.svg?branch=master)](https://travis-ci.com/williampollet/safe_pusher)
[![Maintainability](https://api.codeclimate.com/v1/badges/1aa6c275f9ce4d4c6ec3/maintainability)](https://codeclimate.com/github/williampollet/safe_pusher/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1aa6c275f9ce4d4c6ec3/test_coverage)](https://codeclimate.com/github/williampollet/safe_pusher/test_coverage)

# SafePusher

Run your favorite linters and specs on the files you touched, before pushing your branch

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safe_pusher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe_pusher


To use the gem fully, you should install [pronto](https://github.com/prontolabs/pronto) and [rspec](https://github.com/rspec/rspec) first.

## Configuration

Generate the `binstubs` for `pronto` and `rspec`:

    $ bundler binstubs pronto
    $ bundler binstubs rspec-core

create the `safe_pusher.yml` file at the root of your application

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

To run pronto checks before to push on github run:

    $ safepush lint_push_and_open

or

    $ safepush lpo

To run specs and pronto before to push on github run:

    $ safepush test_lint_push_and_open

or

    $ safepush tlpo

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/williampollet/safe_pusher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafePusher project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_pusher/blob/master/CODE_OF_CONDUCT.md).
