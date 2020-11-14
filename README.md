# Envo

[![Gem Version](https://badge.fury.io/rb/envo.svg)](https://badge.fury.io/rb/envo)

A command-line environment variable manager for the current shell session. It works with bash and Windows cmd.

Envo offers several commands to view and change environment variables and also to execute simple scripts composed of those commands, thus allowing the same script for a particular env-var configuration on all supported platforms.

*Envo is still an alpha version. Not all features are complete and not everything is thoroughly tested.*

## Features

A screenshot of `envo path` which displays the path in a "pretty" way. Note the tags, `D` for an entry which is duplicated, and `N` for an entry which is a non-existing path

![Image](doc/screen/bash-path.png)

Use envo with `envo <command> <args>` in your terminal

### Commands

These are select envo commands. For a full list, check the [command reference](doc/commands.md)

* `show <name> ...` - show values of environment variables in a "pretty" format
* `set <name> = [<value>]` - set a value to an environment variable
* `unset <name> ...` - unset (delete) an environment variabls
* `list <name> add <value>` - add an element to an list environment variable (such as `PATH`)
* `clean <name>` - cleans environment variables. Unsets empty strings, non-existing paths, empty lists. Removes duplicates from lists and non-existing paths from path lists.
* `run <script>` - runs a simple script of commands. See the [script reference](doc/envoscript.md) on how to write scripts

## Installation

* You need a Ruby interpeter version 2.5 or higher
    * To check, type `ruby --version` in your terminal
* Install the ruby gem

```
$ gem install envo
```

* Install the envo command

```
$ envo-install
```

* *If you're using bash, after the last step you'll need to either restart the session, or source the file in which envo was installed (it will be logged after the installation)*

After this you can type

```
$ envo --help
```

... and see the commands and options supported by envo in your terminal.

## Contributing

Issues and pull requests are welcome.

Part of why I created this tool was to refresh my ruby-foo. I hadn't done much ruby programming for years before this. Because of this, envo is not great (not terrible) ruby code. I would welcome PRs or issues which improve the code style and introduce good practices and dev-tooling into the repo.

Please take a look at [the implementation notes](doc/impl-notes.md) and [the roadmap](doc/roadmap.md) if you want to contribute.

## License

This software is distributed under the MIT Software License. See accompanying LICENSE file or copy [here](https://opensource.org/licenses/MIT).

Copyright &copy; 2020 [Borislav Stanimirov](http://github.com/iboB)
