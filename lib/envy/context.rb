module Envy
  class Context
    def initialize(host, log)
      @host = host
      @log = log

      @state = State.new(host.env)
    end

    attr_reader :host, :state

    # parse access
    def expand_name(name)
      name
    end
    def expand_value(val)
      ValBuilder.from_user_text(val, @host)
    end

    # env access
    def smart_get(name)
      ValBuilder.from_env_string(raw_get(name), @host)
    end
    def raw_get(name)
      @state.get(name)
    end

    def smart_set(name, value)
      raw_set(name, value.to_env_s)
    end
    def raw_set(name, value)
      @state.set(name, value)
    end

    # opt queries
    def raw?
      false
    end
    def force?
      false
    end

    def unset(name)
      @state.unset(name)
    end

    # io
    def ask(question)
      print "#{question} (y/n): "
      answer = STDOUT.gets.chomp
      answer.downacase!
      return answer == 'y' || answer == 'yes'
    end

    def error(text); @log.error(text); end
    def warn(text);  @log.warn(text); end
    def print(text); @log.print(text); end
    def puts(text);  @log.puts(text); end
    def debug(text); @log.debug(text); end

    # execution
    def execute(pack)
      pack.cmds.each do |cmd|
        cmd.cmd.execute(self)
      end
    end
  end
end
