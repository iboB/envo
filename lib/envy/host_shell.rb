module Envy
  HostShell = -> {
    env_shell = ENV['SHELL']
    break Shell::WinCmd if !env_shell
    break Shell::Bash if env_shell =~ /bash/
    raise Envy::Error.new "Unknown shell! Please report on https://github.com/iboB/envy/issues" if !shell
  }.()
end
