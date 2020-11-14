# Envo Implementation Notes

## Affecting the current environment

The main idea behind envo is that it affects the current environment. The one in the shell which runs it. This can't be done by `ENV['foo']='bar'` in the ruby code, since it would only affect the environment of the ruby process. So, what envo does is output a shell script (batch or bash) with the appropriate commands.

On cmd dealing with this is easy since batch files are auto-sourced (you need to explicitly forbid sourcing with `setlocal`). Bash doesn't support auto-sourcing, so an alias needs to be created which sources the output of envo. Hence the need for the explicit install step. On cmd the installer creates a batch file in a directory in `Path` and on bash it adds an alias to a dotfile (.bashrc by default). Once [rubygems#88](https://github.com/rubygems/rubygems/issues/88) is resolved, there will be no need for an install step on cmd, but there will still be a need for one on bash.

The way the batch file and the bash alias work is the following:

* Call `envo_run g`. This generates a temporary file which will contain the shell-specific output
* Store the output of `envo_run g` in a local variable
* Call `envo_run pld <tmpfile> <args>`. This will execute the actual envo program with `<args>` and store the shell commands in `<tmpfile>`
* Execute/source `<tmpfile>`. It might be empty if envo ended up not changing any env vars
* Delete `<tmpfile>`

I did consider an alternative approach which would've been a bit faster: output shell-script directly from envo and eval the output from the batch/bash caller. This means that even the text meant for the user would pass through the caller script: printing with `echo`, interacting with `set /p` or `read -p`, and so on. This would only require a single call to `envo_run`, but would have been a real hassle to implement. Especially for batch files. So, I decided against it.

*more to come*

## Parsers

## Commands

## Context

## Scripts


