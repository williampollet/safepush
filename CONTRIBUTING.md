# Contributing

You can easily add a new client, or a new command.

## To add a client
- create the client api under lib/safepush/client/***.rb
- require it in lib/safepush.rb
- write the specs for your client, then submit a PR

You will be able to specify in which command to use it, via the configuration !

## To add a command
- configure your command and its client in config/commands.yml
- create your Safepush client api, as detailed above (if necessary)
- include your command's description in the help, in config/en.yml

# Guidelines

Bug reports and pull requests are welcome on GitHub at williampollet/safepush. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

# Development
Setup development:
`$ bin/setup`

Open a console:
`$ bin/console`

Test the CLI:
`$ ruby -Ilib exe/safepush`

Launch specs and lint:

`$ rake`
