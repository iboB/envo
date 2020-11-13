## TODO

* context vars
* test context
* basic scripts (cmd run)
* script finder
* docs - at least readme. gifs for some example usage
* ci with github actions (can we source stuff on gh's shell?)
* release

## After release

* cmd list-shift
* clean-specific args (`--only[-dedup][-nexist]` - only does these things)
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
