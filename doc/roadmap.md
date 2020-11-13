# Envy Roadmap

These are some ideas for features that can be added to the project

## General

* Suport bash on Windows. The problem here is that bash on Windows does basically the same as envy. It prints BASH-style paths and lists, but launches apps with Windows-CMD-style ones.
* `list shift` command. `list <name> shift <val|index>`
    * `--up` - move up. Always ignore if already first
    * `--down` - move down. Always ignore if already last
    * `--front` - move to front
    * `--back` - move to back
    * `+<i>` - move down by i positions
    * `-<i>` - move up by i positions
* clean-specific args (`--only[-dedup][-nexist]` - only does these things)
* auto-detect extensions for custom types. Search for ruby code in designated places and extend envy with custom user commands and value-types

## CLI

* colors and general terminal niceness
* `envy-install relative`. Assuming there's a sourced alias for envy, we can change the envy scope just for the current session. Would probably be useful when running with bundler


## Scripts

* Allow local variables with `@varname`
* command `ruby` which runs ruby code or executes a ruby script with (perhaps with `instance_eval` on ctx)
* command `find` to search for things, say a python or a node.js installation
* command shorthand, say `<<` to list-add


## Repo

* More docs
* Tutorial for creating types and commands
* Improve code
* Add tooling
* Document lib. The gem includes a library which can perhaps be useful in other ruby projects (not sure how, though)
* CI with github actions. Can we source stuff on gh's shell? Can we test the actual tool and not just run unit tests?
