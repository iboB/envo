module Envy
  module Cli
    class Runner
      def initialize(host, payload)
        @host = host
        @payload = payload
      end
      attr_reader :host, :payload

      VERSION_TEXT = "envy v#{Envy::VERSION} #{Envy::VERSION_TYPE}"
      USAGE = <<~EOF
        usage: envy [--version] [--help] <command> [<args>]
      EOF

      module Opts
        extend self
        def parse_cli(opt)
          case opt
          when '--force', '-f' then return {interact: :force}
          when '--no-force', '-nf' then return {interact: :noforce}
          when '--interactive' then return {interact: :interact}
          when '--raw', '-r' then return {raw: true}
          else raise Envy::Error.new "unknown command line option: #{opt}"
          end
        end
        def print_arg(log, arg, text)
          log.puts "    #{arg.ljust(15)} - #{text}"
        end
        def print_help(log)
          print_arg log, '--force, -f', 'force the execution of the command disregarding checks'
          print_arg log, '--interactive', '(default) ask a question when a check fails'
          print_arg log, '--no-force, -nf', 'produce an error instead of asking questions for checks'
          print_arg log, '--raw, -r', 'don\'t infer types and treat each value as a raw string'
        end
        Defaults = {
          interact: :interact,
          log_level: Logger::INFO
        }
      end

      Commands = [
        CmdShow,
        CmdSet,
        CmdReset,
        CmdUnset,
        CmdList,
        CmdListAdd,
        CmdListDel,
        CmdClean,
        CmdCopy,
        CmdSwap,
        CmdPath,
        CmdRun,
      ]

      def print_version
        @log.puts VERSION_TEXT
      end

      def print_help
        print_version
        @log.puts USAGE
        @log.puts ''
        @log.puts 'Commands:'
        help = Help.new
        Commands.each do |cmd|
          cmd.register_help(help)
        end
        help.print(@log)
        @log.puts ''
        @log.puts 'Common options:'
        Opts.print_help(@log)
      end

      def check_help_ver(argv)
        raise Error.new USAGE if argv.empty?
        case argv[0]
        when '--help', '-h', '-?'
          print_help
          true
        when '--version'
          print_version
          true
        else
          false
        end
      end

      def do_run(argv)
        return if check_help_ver(argv)

        parser = CliParser.new(Opts)
        Commands.each { |cmd| cmd.register_cli_parser(parser) }
        parsed = parser.parse(argv)

        ctx = Context.new(@host, @log, Opts::Defaults)
        ctx.execute(parsed)

        patch = ctx.state.diff

        return if patch.empty?

        patch.removed.each { |name|
          @payload.puts @host.shell.cmd_unset_env_var(name)
          puts @host.shell.cmd_unset_env_var(name)
        }
        patch.changed.each { |name, val|
          @payload.puts @host.shell.cmd_set_env_var(name, val)
          puts @host.shell.cmd_set_env_var(name, val)
        }
        patch.added.each { |name, val|
          @payload.puts @host.shell.cmd_set_env_var(name, val)
          puts @host.shell.cmd_set_env_var(name, val)
        }
      end

      def run(argv)
        @log = Logger.new
        begin
          do_run(argv)
          return 0
        rescue Error => e
          @log.error e.message
          return 1
        end
      end
    end
  end
end
