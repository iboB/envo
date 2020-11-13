$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

module Envo
  autoload :VERSION, "envo/version"
  autoload :Error, "envo/error"
  autoload :NoVal, "envo/val/no_val"
  autoload :StringVal, "envo/val/string_val"
  autoload :ListVal, "envo/val/list_val"
  autoload :PathVal, "envo/val/path_val"
  autoload :PathListVal, "envo/val/path_list_val"
  autoload :CmdSet, "envo/cmd_set"
  autoload :CmdReset, "envo/cmd_reset"
  autoload :CmdUnset, "envo/cmd_unset"
  autoload :CmdListAdd, "envo/cmd_list_add"
  autoload :CmdListDel, "envo/cmd_list_del"
  autoload :CmdShow, "envo/cmd_show"
  autoload :CmdSwap, "envo/cmd_swap"
  autoload :CmdRun, "envo/cmd_run"
  autoload :CmdList, "envo/cmd_list"
  autoload :CmdPath, "envo/cmd_path"
  autoload :CmdClean, "envo/cmd_clean"
  autoload :CmdCopy, "envo/cmd_copy"
  autoload :State, "envo/state"
  autoload :ValBuilder, "envo/val/val_builder"
  autoload :Context, "envo/context"
  autoload :ParsedCmd, "envo/parsed_cmd"
  autoload :CliParser, "envo/cli_parser"
  autoload :ScriptParser, "envo/script_parser"
  autoload :HostShell, "envo/host_shell"
  autoload :Host, "envo/host"
  autoload :ParseResult, "envo/parse_result"
  autoload :Logger, "envo/logger"

  module Shell
    autoload :Bash,   'envo/shell/bash'
    autoload :WinCmd, 'envo/shell/win_cmd'
  end

  module Cli
    autoload :Runner, 'envo/cli/runner'
    autoload :Help, 'envo/cli/help'
    autoload :InstallerWinCmd, 'envo/cli/installer_win_cmd'
    autoload :InstallerBash, 'envo/cli/installer_bash'
  end
end
