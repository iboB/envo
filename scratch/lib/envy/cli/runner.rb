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

    CMD_SHORTCUTS = {
      's' => 'show',
      'p' => 'path',

      'la' => 'list-add',
      'ld' => 'list-del',
      'c' => 'clean',
      'pa' => 'path-add',
      'pc' => 'path-clean',
      'pd' => 'path-del',
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

    def runner_cmd(cmd, args)
      builder = Builder.new(@sys)
      runner = CmdRunner.new(@sys, @io, builder)
      runner.run_command(cmd, args)

      patch = builder.diff
      if patch.empty
        @io.puts "There are changes to the environment"
      else
        patch.removed.each { |name| @io.unset_env_var(name) }
        patch.changed.each { |name, val| @io.set_env_var(name, val) }
        patch.added.each { |name, val| @io.set_env_var(name, val) }
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
      cmd = CMD_SHORTCUTS[cmd] || cmd

      # locals
      case cmd
        when 'show' then show(cmd_args)
        when 'rshow' then raw_show(cmd_args)
        when 'path' then show([@sys.path_var_name])
        else runner_cmd(cmd, cmd_args)
      end
    end

    def output
      @io.output
    end
  end
end
