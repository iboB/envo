require 'rbconfig'

module Envy
  module HostSystemBase
    def platform
      self.class::Platform
    end

    def env
      ENV
    end
  end

  class HostSystemWin
    include HostSystemBase
    Platform = Platform::Windows
    def initialize
      @path_var_name = ENV.keys.find { |var| var.upcase == 'PATH' }
      @path_var_name = 'Path' if !@path_var_name
    end
    attr_reader :path_var_name
  end

  class HostSystemUnixLike
    include HostSystemBase
    Platform = Platform::UnixLike
    def path_var_name
      'PATH'
    end
  end

  HostSystem = lambda {
    host_os = RbConfig::CONFIG['host_os']
    is_win = host_os =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    is_win ? HostSystemWin.new : HostSystemUnixLike.new
  }.()
end
