module Envo
  class CmdSwap
    Name = 'swap'
    def self.register_help(help)
      help.add_cmd 'swap <name1> <name2>', "swap values of two environment variables"
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_tokens(tokens, opts) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      parse_tokens(args, opts)
    end

    def self.parse_tokens(args, opts)
      raise Envo::Error.new "swap: provide two names to swap. Use 'swap <name1> <name2>'" if args.size != 2
      ParsedCmd.new(CmdSwap.new(args[0], args[1]), opts)
    end

    def initialize(name_a, name_b)
      @name_a = name_a
      @name_b = name_b
    end

    attr_accessor :name_a, :name_b

    def execute(ctx)
      ea = ctx.expand_name(@name_a)
      raw_a = ctx.raw_get(ea)
      raise Envo::Error.new "swap: no such var '#{ea}'" if !raw_a && !ctx.force?

      eb = ctx.expand_name(@name_b)
      raw_b = ctx.raw_get(eb)
      raise Envo::Error.new "swap: no such var '#{eb}'" if !raw_b && !ctx.force?

      return if ea == eb # swap something with itself...
      return if !raw_a && !raw_b # no point in doing anything if they don't exist

      ctx.raw_set(ea, raw_b)
      ctx.raw_set(eb, raw_a)
    end
  end
end
