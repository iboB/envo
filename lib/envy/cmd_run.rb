module Envy
  class CmdRun
    Name = 'run'
    def self.register_help(help)
      help.add_cmd 'run <script>', <<~EOF
        run a script of envy commands
        auto appends a .envy to script unless it's a relative path (begins with '.')
        searches for scripts in .envy/ subdirs of current tree and in <home>/.envy/
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

    def execute(ctx)
      # script = ctx.load_script(@script)
      # script.run
    end
  end
end
