$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envy
  autoload :VERSION, "envy/version"
  autoload :Error, "envy/error"
  autoload :NoVal, "envy/val/no_val"
  autoload :StringVal, "envy/val/string_val"
  autoload :ListVal, "envy/val/list_val"
  autoload :PathVal, "envy/val/path_val"
  autoload :PathListVal, "envy/val/path_list_val"
  autoload :CmdSet, "envy/cmd_set"
  autoload :CmdReset, "envy/cmd_reset"
  autoload :CmdUnset, "envy/cmd_unset"
  autoload :CmdListAdd, "envy/cmd_list_add"
  autoload :CmdListDel, "envy/cmd_list_del"
  autoload :CmdShow, "envy/cmd_show"
  autoload :CmdSwap, "envy/cmd_swap"
  autoload :State, "envy/state"
  autoload :ValBuilder, "envy/val/val_builder"
  autoload :Context, "envy/context"
  autoload :ParsedCmd, "envy/parsed_cmd"
  autoload :CliParser, "envy/cli_parser"
  autoload :HostShell, "envy/host_shell"
  autoload :Host, "envy/host"
  autoload :ParseResult, "envy/parse_result"
  autoload :Logger, "envy/logger"

  module Shell
    autoload :Bash,   'envy/shell/bash'
    autoload :WinCmd, 'envy/shell/win_cmd'
  end

  module Cli
    autoload :Runner, 'envy/cli/runner'
    autoload :Help, 'envy/cli/help'
    autoload :InstallerWinCmd, 'envy/cli/installer_win_cmd'
    autoload :InstallerBash, 'envy/cli/installer_bash'
  end
end
