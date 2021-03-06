module Envo
  class CmdClean
    Name = 'clean'
    def self.register_help(help)
      help.add_cmd "clean <name> ...", <<~EOF
        cleans environent variables
        unsets empty strings, non-existing paths, empty lists
        removes duplicates from lists and non-existing paths from path lists
      EOF
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

    def self.parse_tokens(tokens, opts)
      ParsedCmd.new(CmdClean.new(tokens), opts)
    end

    def initialize(names)
      raise Error.new 'clean: no names provided' if names.empty?
      @names = names
    end

    attr_reader :names

    def execute(ctx)
      @names.each do |name|
        ename = ctx.expand_name(name)

        if ctx.raw?
          val = ctx.raw_get(ename)
          ctx.unset(ename) if val && val.empty?
        else
          val = ctx.smart_get(ename)
          if val.type != :empty
            val.clean!
            ctx.smart_set(ename, val)
          end
        end
      end
    end
  end
end
