module Envy
  class Context
    def initialize(host, log, opts, state = nil)
      @host = host
      @log = log
      @default_opts = opts
      @opts = opts
      reflect_opts_change

      @state = state || State.new(host.env)

      create_common_locals
    end

    attr_reader :host, :state

    # create another context based on this one (same state, log, and host)
    # which provides different opts an locals
    # thus scripts can be executed which don't leak values in the scope above
    def new_scope(defaults = {})
      Context.new(@host, @log, @opts.merge(defaults), @state)
    end

    def find_script(script)
      if @host.shell.likely_rel_path?(script) || @host.shell.likely_abs_path?(script)
        return script if @host.path_exists?(script)
        raise Envy::Error.new "'#{script}' doesn't exist"
      end

      # look for '.envy/<file>.envyscript'
      script = script + '.envyscript'
      dir = @host.pwd
      found = while true
        check = File.join(dir, '.envy', script)
        break check if @host.path_exists?(check)
        new_dir = File.dirname(dir)
        break nil if new_dir == dir
        dir = new_dir
      end

      if !found
        check = File.join(@host.home, '.envy', script)
        found = check if @host.path_exists?(check)
      end

      raise Envy::Error.new "Can't find '#{script}' in .envy/ parent dirs or in <home>/.envy/" if !found
      found
    end

    def load_script(path)
      File.readlines(path)
    end

    # parse access
    def expand_name(name)
      @locals[name] || name
    end
    def expand_value(val)
      if raw?
        if val.class == Array
          if val.size == 1
            StringVal.new(val[0])
          else
            ListVal.new(val)
          end
        else
          StringVal.new(val)
        end
      else
        ValBuilder.from_user_text(val, @host)
      end
    end
    # local vars
    def local_var_name?(name)
      name =~ /^@[a-zA-Z]/
    end
    def set_local_var(name, value)
      @locals[name] = value
    end
    def create_common_locals
      @locals = {
        '@path' => host.shell.path_var_name,
        '@home' => host.shell.home_var_name,
      }
    end

    # env access
    def smart_get(name)
      ValBuilder.from_env_string(raw_get(name), @host)
    end
    def raw_get(name)
      @state.get(name)
    end

    def smart_set(name, value)
      if value.list?
        rv = @host.shell.ar_to_list(value.ar)
        raw_set(name, rv)
      else
        raw_set(name, value.to_env_s)
      end
    end
    def raw_set(name, value)
      @state.set(name, value)
    end

    def unset(name)
      @state.unset(name)
    end

    # opt queries
    def raw?
      @opts[:raw]
    end
    def force?
      @opts[:interact] == :force
    end
    def noforce?
      @opts[:interact] == :noforce
    end
    def interact?
      @opts[:interact] == :interact
    end

    def reflect_opts_change
      @log.max_level = @opts[:log_level]
    end

    # io
    def ask(question)
      return true if force?
      return false if noforce?

      print "#{question} (y/n): "
      answer = STDIN.gets.chomp
      answer.downcase!
      return answer == 'y' || answer == 'yes'
    end

    def error(text); @log.error(text); end
    def warn(text);  @log.warn(text); end
    def print(text); @log.print(text); end
    def puts(text);  @log.puts(text); end
    def debug(text); @log.debug(text); end

    # execution
    def execute(pack)
      pack_opts = pack.opts
      pack.cmds.each do |cmd|
        @opts = @default_opts.merge(cmd.opts, pack_opts)
        reflect_opts_change
        cmd.cmd.execute(self)
      end
    end
  end
end
