require 'rbconfig'

module Envy
  module HostSystemBase
    def platform
      self.class::Platform
    end

    def env
      ENV
    end

    def pwd
      Dir.pwd
    end
  end

  class HostSystemWin
    include HostSystemBase
    Platform = Platform::Windows
  end

  class HostSystemUnixLike
    include HostSystemBase
    Platform = Platform::UnixLike
  end

  HostSystem = lambda {
    host_os = RbConfig::CONFIG['host_os']
    is_win = host_os =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    is_win ? HostSystemWin.new : HostSystemUnixLike.new
  }.()
end
