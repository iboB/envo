module Envy
  class System
    def initialize(p)
      @p = p
      @pwd = p.name == 'Windows' ? 'C:\\' : '/'
      @env = {}
    end

    attr_accessor :pwd
    attr_reader :env

    def merge_env(h)
      env.merge!(h)
    end

    def platform
      @p
    end
  end
end
