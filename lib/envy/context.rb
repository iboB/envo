module Envy
  class Context
    def initialize(host, logger)
      @host = host
      @logger = logger
    end

    def expand_name(name)
      name
    end
    def expand_value(val)
      val
    end

    def smart_get(name)
    end
    def raw_get(name)
      @state.get(name)
    end
    def smart_set(name, value)
    end
    def raw_set(name, value)
    end

    def opts
      @opts
    end

    def ask(question)
    end
  end
end
