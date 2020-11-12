module Envy
  module Cli
    class Runner
      def initialize(host, payload)
        @host = host
        @payload = payload
      end
      attr_reader :host, :payload

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
        Defaults = {
          interact: :interact,
          log_level: Logger::INFO
        }
      end

      Commands = [
        CmdShow,
        CmdUnset,
        CmdSet,
        CmdListAdd,
      ]

      def do_run(argv)
        parser = CliParser.new(Opts)
        Commands.each { |cmd| cmd.register_cli_parser(parser) }
        parsed = parser.parse(ARGV)

        ctx = Context.new(@host, @logger, Opts::Defaults)
        ctx.execute(parsed)

        patch = ctx.state.diff

        return if patch.empty?

        patch.removed.each { |name|
          @payload.puts @host.shell.cmd_unset_env_var(name)
        }
        patch.changed.each { |name, val|
          @payload.puts @host.shell.cmd_set_env_var(name, val)
        }
        patch.added.each { |name, val|
          @payload.puts @host.shell.cmd_set_env_var(name, val)
        }
      end

      def run(argv)
        @logger = Logger.new
        begin
          do_run(argv)
          return 0
        rescue Error => e
          @logger.error e.message
          return 1
        end
      end
    end
  end
end
