module Envo
  class CmdList
    Name = 'list'
    def self.register_help(help)
      help.add_cmd "list <name>", "show value of list environment variable which is a list"
      help.add_cmd "list <name> add <val>", <<~EOF
        add value to list if it's not already inside
          --front - adds value to front of list (moves it to front if it's already inside)
          --back  - adds value to back of list (moves it to back if it's already inside)
      EOF
      help.add_cmd "list <name> del <val|index>", <<~EOF
        remove a value from a list
        if the provided value is an integer, it's interpreted as an index in the list
      EOF
      help.add_cmd "list <name> clean", "the same as 'clean <name>' (convenience command)"
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts_front(args)
      raise Envo::Error.new "list: missing name. Use 'list <name> <cmd> <args>'" if args.empty?
      name = args.shift
      return ParsedCmd.new(CmdShow.new([name], true), opts) if args.empty? # just list <name>

      cmd = args.shift
      return CmdListAdd.parse_cli_args(name, args, opts) if cmd == 'add'
      return CmdListDel.parse_cli_args(name, args, opts) if cmd == 'del'
      if cmd == 'clean'
        opts += CliParser.filter_opts_back(args)
        raise Envo::Error.new "list-clean: no args needed. Use 'list <name> clean'" if !args.empty?
        return CmdClean.parse_tokens([name], opts)
      end

      raise Envo::Error.new "list: unkonwn subcommand #{cmd}"
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_script(tokens, opts) })
    end

    def self.parse_script(tokens, opts)
      raise Envo::Error.new "list: missing name. Use 'list <name> <cmd> <args>'" if tokens.empty?
      name = tokens.shift
      return ParsedCmd.new(CmdShow.new([name], true), opts) if tokens.empty? # just list <name>

      cmd = tokens.shift
      return CmdListAdd.parse_script(name, tokens, opts) if cmd == 'add'
      return CmdListDel.parse_tokens(name, tokens, opts) if cmd == 'del'
      return CmdClean.parse_tokens([name], opts) if cmd == 'clean'

      raise Envo::Error.new "list: unkonwn subcommand #{cmd}"
    end
  end
end
