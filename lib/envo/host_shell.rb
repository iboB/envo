module Envo
  HostShell = -> {
    env_shell = ENV['SHELL']
    break Shell::WinCmd if !env_shell
    if env_shell =~ /bash/
      raise Error.new "bash on Windows (msys) is not supported yet" if env_shell =~ /^[a-zA-Z]\:/
      break Shell::Bash
    end
    raise Error.new "Unknown shell! Please report on https://github.com/iboB/envo/issues"
  }.()
end
