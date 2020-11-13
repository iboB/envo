module Envo
  class CmdUnset
    Name = 'unset'
    def self.register_help(help)
      help.add_cmd 'unset <name> ...', "unset values of one or more environment variables"
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_tokens(tokens, opts) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      ParsedCmd.new(CmdUnset.new(args), opts)
    end

    def self.parse_tokens(tokens, opts)
      ParsedCmd.new(CmdUnset.new(tokens), opts)
    end

    def initialize(names)
      raise Envo::Error.new 'unset: no names provided' if names.empty?
      @names = names
    end

    attr_reader :names

    def execute(ctx)
      @names.each do |name|
        ename = ctx.expand_name(name)
        raw_old_val = ctx.raw_get(ename)

        if raw_old_val
          ctx.unset(ename)
        else
          raise Envo::Error.new "unset: no such var '#{ename}'" if !ctx.force?
        end
      end
    end
  end
end
