module Envy
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
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_script(args) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts_front(args)
      raise Envy::Error.new "list: missing name. Use 'list <name> <cmd> <args>'" if args.empty?
      name = args.shift
      return ParsedCmd.new(CmdShow.new([name], true), opts) if args.empty? # just list <name>

      cmd = args.shift
      return CmdListAdd.parse_cli_args(name, args, opts) if cmd == 'add'
      return CmdListDel.parse_cli_args(name, args, opts) if cmd == 'del'

      raise Envy::Error.new "list: unkonwn subcommand #{cmd}"
    end
  end
end
