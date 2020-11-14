# Envo Commands

## Options

The following options are valid for every command:

* `--interactive` - Prompt the user with a yes/no question in certain potentially unwanted scenarios. This is the default behavior of the CLI and you don't need to set it manually
* `--force`, `-f` - Don't ask yes/no questions and assume the answer to every question is 'yes'. This is the default behavior of scripts
* `--no-force`, `-nf` - Don't ask yes/no questions and assume the answer is 'no'. This will trigger an error on the first occasion where a question would be asked.
* `--raw`, `-r` - Treat each value as a string and don't try to infer the type

Certain commands have their own additional specific options

## Printer commands

The follwing commands don't change the environment and only display values of env vars

* `show <name> ...` - Display the values of environment variables. Tries to infer the type from the value and displays it in a "pretty" format. With `--raw` the inferrence doesn't happen and it will output the exact value of the env var. Multiple names can be added to the command and they will all be displayed.
    * `--name` - Adding `--name` to `show` will also display the env var name with each value value like `<name>=<value>`
* `rshow <name> ...` - Raw show. A shorthand syntax for `show --raw <name> ...`
* `path` - Display the value of `PATH` environment variable. Implies `--name`
* `list <name>` - Display the value of an env var which is a list. Works exactly the same way as `show` and is just there to make the implementation of `path` easier

## Modifier commands

The follwing commands can modify environment variables. Note that if they don't end up making modifications, no commands to the shell will be issued. For example setting `foo` too `bar` won't produce a shell command if `foo` if already `bar`.

All names of env vars are case-sensitive. Even on Windows.

Unless you set the `--raw` option, envo will try to infer the type of the values provided to these commands. For example `set mypath = ./dir` will expand `./dir` to a full absolute path from the current working directory. With `--raw` the provided value is treated as a string.

Envo will also try to infer the previous value of the variable and warn if they're incompattible. For example `set mypath = foo` will warn that the string "foo" doesn't look like a path. With `--force` these checks won't happen and the provided value will always be treated as a compatible with the target variable.

* `set <name>=<val>` - Set an env var to a specific value. `set <name>=` unsets (removes) the env var.
* `reset <name>[=[<val>]]` - Reset an existing env var to a specific value. Will produce an error if the target var doesn't exist, even with `--force`. `reset <name>` unsets (removes) the env var.
* `unset <name> ...` - Unset (remove) one or more env vars. With `--force` non-existing vars will be ignored, otherwise an error will be produced.
* `list <name> add <val>` - Add a value to list if it's not already inside. If the value is already in the list, it will ignore the command unless it has to reorder it:
    * `--front`, `--top` - Add the value to the front of the list. If the value is already inside, it will be moved to the front
    * `--back`, `--bottom` - Add the value to the back of the list. If the value is already inside, it will be moved to the back
    * `la <name> <val>` is a shorthand syntax for this command
* `list <name> del <val|index>` - Remove a given value or the value at a specified index from a list. If an integer is given, an index will be inferred. To remove a element which is integer by value from a list, you need to use `--raw`
    * `ld <name> <val|index>` is a shorthand syntax for this command
* `clean <name> ...` - Clean one or more env vars. "Cleaning" means inferring the type and:
    * Unset vars which have invalid values: empty strings, non-existing paths, empty lists
    * Remove duplicate elements of lists
    * For lists of paths remove elements which are non-existing paths
* `list <name> clean` - Same as `clean <name>`. Is just there to make the implementation of `path clean` easier
* `copy <source-name> <target-name>` - Copy an env var value to another env var. Unless you use `--force` will warn if the target exists and ask for a confirmation.
    * `cp <source-name> <target-name>` is a shorthand syntax for `copy`
* `swap <name-1> <name-2>` - Swap the values of two env vars
* `path add <val>` - Same as `list-add`, but for the `PATH` env var
* `path del <val>` - Same as `list-del`, but for the `PATH` env var
* `path clean` - Same as `clean`, but for the `PATH` env var

For convenience, you can use envo-specific strings `@path` and `@home` which expand to the name (*not the value*) of the shell-specific `PATH` and `HOME` env vars. Thanks to this all `path ...` commands actually expand to `list @path ...`.

## Run script commands

`run <script>`

This command will run a **envoscript** script. Check out the [envoscript reference](envoscript.md).

If `<script>` is a relative path or an absolute path (say `./subdir/somefile` or `D:\myscript.txt`), the command will try to load the exact filename (appending a relative path to the current working directory). If the file doesn't exist, an error will be produced.

If `<script>` is name, say `myscript`, the command will look for a file called `myscript.envoscript` in a subdirectory `.envy/` in the current working directory and, if it's not there, in each parent directory of the current one up to the root. If the file still isn't found, it will try `.envy/myscript.envocript` in the home directory. If the file is not in any of these places, an error will be produced.

