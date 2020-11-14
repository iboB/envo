# Envo Script

Envoscript allows the batching of several envy commands at once. The main difference between envoscript and the CLI syntax is options. In the CLI options are added with `--option`. In envoscript options are added at the beginning of the line in brackets (`{}`).

* `Comments` are lines which start with the hash `#` symbol. Comments which are not an entire line of code are not supported.
* `Empty lines` are ignored
* `Whitespace at the beginning a line` is ignored
* `Commands` are all other lines. If the line starts with an open bracket `{`, this is an option pack, where options are separated with commas.

## Example:

```
# set python2 as the default python interpreter
set PYTHON = C:\python2\bin\pyton.exe
{front} path add C:\python2\bin
# display the newly formed path for convenience
{name,raw} show @path
```
