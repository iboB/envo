module Envy
  class CmdRun
    Name = 'run'
    def self.register_help(help)
      help.add_cmd 'run <script>', <<~EOF
        run a script of envy commands
        if script is a relative or an absolute path, it tries to load the exact filename
        otherwise it searches for '<script>.envyscript' in .envy/ subdirs of current tree and in <home>/.envy/
      EOF
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      raise Envy::Error.new "run: provide a single script name. Use 'run <script>'" if args.size != 1
      ParsedCmd.new(CmdRun.new(args[0]), opts)
    end

    def initialize(script)
      @script = script
    end

    attr_reader :script

    module Opts
      extend self
      def parse_script(opt)
        case opt
        when 'force' then return {interact: :force}
        when 'no-force' then return {interact: :noforce}
        when 'interactive' then return {interact: :interact}
        when 'raw' then return {raw: true}
        else raise Envy::Error.new "script option: #{opt}"
        end
      end
    end

    def execute(ctx)
      file = ctx.find_script(@script)
      lines = ctx.load_script(file)
      parser = ScriptParser.new(Opts)

      [
        CmdShow,
        CmdSet,
        CmdReset,
        CmdUnset,
        CmdList,
        CmdClean,
        CmdCopy,
        CmdSwap,
        CmdPath,
        CmdRun,
      ].each { |cmd| cmd.register_script_parser(parser) }

      res = parser.parse(lines)

      scope = ctx.new_scope({interact: :force})
      scope.execute(res)
    end
  end
end
