$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION, "envy/version"
  autoload :Error, "envy/error"
  autoload :NoVal, "envy/val/no_val"
  autoload :StringVal, "envy/val/string_val"
  autoload :CmdSet, "envy/cmd_set"
  autoload :CmdUnset, "envy/cmd_unset"
  autoload :State, "envy/state"
  # autoload :Context, "envy/context"
  autoload :ParsedCmd, "envy/parsed_cmd"
  autoload :CliParser, "envy/cli_parser"
  autoload :HostShell, "envy/host_shell"
  autoload :HostSystem, "envy/host_system"

  module Shell
    autoload :Bash,   'envy/shell/bash'
    autoload :WinCmd, 'envy/shell/win_cmd'
  end
end
