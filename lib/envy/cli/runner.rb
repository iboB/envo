module Envy
  class Runner
    def initialize(sys)
      @sys = sys
      @io = sys.platform.make_io
    end

    VERSION_TEXT = "envy v#{Envy::VERSION}"
    USAGE = <<~ENDUSAGE
      usage: envy <command> [<args>]
    ENDUSAGE
    HELP = <<~ENDHELP
      HELP HELP
    ENDHELP

    CMD_NAME_TO_SYM = {
      's' => :show,
      'show' => :show,
      'rshow' => :raw_show,
      'p' => :path_show,
      'path' => :path_show,
      'set' => :raw_set,
      'la' => :list_add,
      'list-add' => :list_add,
      'ld' => :list_del,
      'list-del' => :list_del,
    }

    def show(names)
      env = @sys.env
      names.each do |name|
        Envy::VarBuilder.build(@sys, name, env[name]).pretty_print(@io)
      end
    end

    def raw_show(names)
      env = @sys.env
      names = env.keys if names.empty?
      names.each do |name|
        val = env[name]
        if !val
          @io.puts "No environment variable '#{name}'"
        else
          @io.puts "#{name}=#{val}"
        end
      end
    end

    def raw_set(name, val)
      @io.set_env_var(name, val)
    end

    def list_add(name, vals)
      raw_list = @sys.env[name]
      list = Envy::VarBuilder.build(@sys, name, raw_list).interactive_to_list(@io)
      vals.each do |val|
        list.insert(val)
      end

      ev = list.to_env_val
      if raw_list != ev
        @io.set_env_var(list.name, list.to_env_val)
      else
        @io.puts "No changes"
      end
    end

    def list_del(name, elem)
      raw_list = @sys.env[name]
      list = Envy::VarBuilder.build(@sys, name, raw_list).interactive_to_list(@io)

      index = elem.to_i
      deleted = if index.to_s == elem
        list.delete_at(index)
      else
        list.delete(elem)
      end

      if deleted
        @io.set_env_var(list.name, list.to_env_val)
      else
        @io.puts "No item '#{elem}' in #{name}"
      end
    end

    def do_run(argv)
      opts = {}
      cmd = ''

      while !argv.empty? do
        arg = argv.shift
        case arg
          when '-h', '--help', 'help' then opts[:help] = true
          when '-v', '--version'      then opts[:ver] = true
          else break cmd = arg
        end
      end

      opts[:help] = true if cmd.empty?

      if opts[:ver]
        @io.puts VERSION_TEXT
        return 0
      end

      if opts[:help]
        @io.puts VERSION_TEXT
        @io.puts USAGE
        @io.puts HELP
        return 0
      end

      if cmd[0] == '-'
        @io.error "unkown option: #{cmd}"
        @io.error USAGE
        return 1
      end

      cmd_args = argv

      ################################
      # commands
      cmd_sym = CMD_NAME_TO_SYM[cmd]

      if !cmd_sym
        @io.error "envy: '#{cmd}' is not an envy command. See 'envy --help'"
        return 1
      end

      ################################
      # we might actually have something to do
      {
        :show => -> { show(cmd_args) },
        :raw_show => -> { raw_show(cmd_args) },
        :path_show => -> { show([@sys.path_var_name]) },
        :raw_set => -> {
          raise Envy::Error.new "set requires more arguments. Use 'set <var> <value>'" if cmd_args.size < 2
          raw_set(cmd_args[0], cmd_args[1..].join(' '))
        },
        :list_add => -> {
          raise Envy::Error.new "list-add requires more arguments. Use 'list-add <var> <value> [<value>...]'" if cmd_args.size < 2
          list_add(cmd_args[0], cmd_args[1..])
        },
        :list_del => -> {
          raise Envy::Error.new "list-del requires two arguments. Use 'list-del <var> <value|index>'" if cmd_args.size != 2
          list_del(cmd_args[0], cmd_args[1])
        },
      }[cmd_sym].()
    end

    def output
      @io.output
    end
  end
end
