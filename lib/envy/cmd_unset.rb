module Envy
  class CmdUnset
    Name = 'unset'
    def self.register_help(ctx)
      ctx.help.add_cmd(Name, "unset one or more vars")
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_script(args) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      ParsedCmd.new(CmdUnset.new(args), opts)
    end

    def initialize(names)
      raise Envy::Error.new 'unset: no names provided' if names.empty?
      @names = names
    end

    attr_reader :names

    def execute(ctx)
      @names.each do |name|
        ename = ctx.expand_name(name)
        raw_old_val = ctx.raw_get(ename)
        raise Envy::Error.new "unset: no such var '#{ename}'" if !raw_old_val && !ctx.opts[:force]
        ctx.unset(ename)
      end
    end
  end
end
