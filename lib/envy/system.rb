module Envy
  class System
    def initialize(p)
      @p = p
      @env = {}
    end

    attr_reader :env

    def merge_env(h)
      env.merge!(h)
    end

    def platform
      @p
    end
  end
end
