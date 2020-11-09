module Envy
  HostShell = -> {
    env_shell = ENV['SHELL']
    break Shell::WinCmd if !env_shell
    break Shell::Bash if env_shell =~ /bash/
    nil
  }.()
end
