* multi-apply tests

## Commands

### Printer

* `show <name>` - show pretty version of var
    * `--raw` - show exact value of env
    * `--name` - show `name=<val>`
* `rshow <name>` - shorcut to `show --raw`
    * `--name` - show `name=<val>`
* `name <name>` - show name of var
* `@<var>` - shorcut to name of var
* `path` - show path `show @path`
* `p` - `path`

### Changer

* `set <name>=[<val>]` - smart set. Check for old-new val compatibility. Convert. Set with no val = unset
    * `--force` - doesn't check for compat
    * `--no-force` - errors if incompatible
    * `--raw` - input value is string
* `reset <name>[=[<val>]]` - checks if val exists, errors if it doesn't
    * `--force` - doesn't check for compat
    * `--no-force` - errors if incompatible
    * `--raw` - input value is string
* `unset <name>` - unsets name
    * `--force` - doesn't error if name doesn't exist
* `list <name> add <val>` - adds val to list. If val is list adds all. If val is in list, reorders
    * `--force` - ignores if name isn't a list, ignores val compatibility with list types
    * `--no-force` - erros if any of the above
    * `--raw` - val is string
    * `--front` - adds val to front
    * `--back` - adds val to back
* `la` - shortcut to list add
* `list <name> del <val|index>` - removes val from list, or element at index
    * `--force` - no error if name isn't a list or if val or index is not of list
    * `--raw` - val is string
* `ld` - shortcut to list del
* `list <name> shift <val|index>`
    * `--up` - always ignore if already first
    * `--down` - always ignore if already last
    * `--front`
    * `--back`
    * `--raw` - val is string
    * `--force` - no error if not list, or val or index is not of list
* `clean <name>` - cleans name (removes list duplicates, removes non-existing paths)
    * `--force` - no error if name is not a var
    * `--only[-dedup][-nexist]` - only does these things
* `swap <name> <other>` - swap values of two vars. does nothing if any doesn't exist
    * `--force` - no error any of them doesn't exist
* `copy <name> <other>` - copy value of name to other
    * `--force` - overwrite
    * `--no-force` - error if other exists
* `cp` - shortcut to copy
* `move <name> <other>` - move value of name to other
    * `--force` - overwrite
    * `--no-force` - error if other exists
* `mv` - shortcut to move
* `path add <val>` - `list @path add <val>`
* `path del <val>` - `list @path del <val>`
* `path shift <val>` - `list @path shift <val>`
* `path clean` - `clean @path`

### Script

* `run <script>` - run a script of commands, script is force but not no-error
* `@<name>` - local variable
* `$<name>` - refer to env var's value
* `echo <text>` - prints text to stdout

### Vars

* `@path` - name of path var
* `@home` - name of home var
