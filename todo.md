## TODO

* context vars
* test context
* cmd list-shift
* cmd list (dispatcher to specific command)
* cmd clean
* cmd copy and move (they are small ones and can be done on one go)
* cmd path (dispatch)
* basic scripts (cmd run)
* script finder
* installers (`shell.installer`)
* temp shell script generation
* cli - basically combine scratch/cli and scratch.rb
* docs - at least readme. gifs for some example usage
* ci with github actions (can we source stuff on gh's shell?)
* release

## After release

* bash on Windows (it basically the same as envy as it prints BASH-style paths and lists, but launches apps with Windows-CMD-style :) )
* colors
* script commands
    * find
    * rel path
    * shorthand (`<<` to list-add for example)
    * have ruby code in scripts
* envy-install relative (assuming there's a sourced alias for envy we can change the envy scope just for the current session)
* tutorial for custom types
* auto-detect extensions for custom types (need to find ruby code and a custom val builder)
