# DevOops

This is a gem to help you manage all the scripts and repetitive commands you have written and scatered over the years

## Installation

There's 2 main ways to install and use this gem.

### Global install

    $ gem install dev_oops && dev_oops install

This will create a `$Home/.dev_oops` directory.

### Local install

Use the global `dev_oops` gem.

#### Bundler way

Add this gem to your Gemfile

```
gem 'dev_oops'
```

Then `bundle install` and run `bundle exec dev_oops local_install`.

This will create a `./dev_oops` directory.

## Usage

This gem will install a new command named `dev_oops`. You can use it from anywhere.

### TL;DR example

Config (`dev_oops edit hello`):

```json
{
  "desc": "Say hello.",
  "usage": "[--firstname name]",
  "args": [
    {
      "name": "firstname",
      "desc": "Firstname of the person",
      "aliases": ["f"],
      "required": false,
      "default": "Pierre"
    }
  ]
}
```

Script (`dev_oops edit_sh hello`):

```sh
echo "Hello $firstname !"
```

Shell:

```sh
dev_oops hello --firstname Emy # => Hello Emy !
dev_oops hello -f Chris # => Hello Chris !
dev_oops hello # => Hello Pierre !
dev_oops help hello # =>
# Usage:
#   hello [--firstname name]
#
# Options:
#   f, [--firstname=FIRSTNAME]  # Firstname of the person
#                               # Default: Pierre
```

### Commands

Which editor will be opened by the gem

#### install

`dev_oops install` Will create the base directory needed for storing your scripts.

#### edit

`dev_oops edit name_of_script` Will open in `$EDITOR` your script [configuration](#config-format).

#### edit_sh

`dev_oops edit_sh name_of_script` Will open in `$EDITOR` your script body. Note that the script will be run in `$SHELL`

#### rm

`dev_oops rm name_of_script` Will remove the config file and the body file from your disk.

#### help

`dev_oops help [COMMAND]` Will show help.

#### [your command]

`dev_oops [your_command]` Will launch the command.

### Config format

Most of the fields are optionals. I would advise filling "desc" and "usage".

```json
{
    "desc": "A description for what the command do. Will be shown in help.",
    "usage": "A short usage description. This will be shown in help. The name of the command will be automatically present at the beggining of the usage",
    "args": [
        {
            "name": "name_of_the_arg",
            "desc": "Description of what the arg does. Will be shown in help.",
            "aliases": ["a"],
            "required": false,
            "default": "aaaaa"
        },
        …
    ]
}
```

#### Arg format

The `name` will be used to pass the value in the script as an env variable.
You can then access the value with `$name` in the shell script.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zaratan/dev_oops. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/zaratan/dev_oops/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DevOops project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/zaratan/dev_oops/blob/master/CODE_OF_CONDUCT.md).
