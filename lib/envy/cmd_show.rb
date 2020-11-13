module Envy
  class CmdShow
    Name = 'show'
    def self.register_help(help)
      help.add_cmd "show <name> ...", <<~EOF
        show values of environment variables
          --name - display the name of the variable along with the value
          shorhand: 's'
      EOF

      help.add_cmd 'rshow <name> ...', <<~EOF
        show the *raw* value of environment variables with no pretty prints
        a shortcut to 'show --raw <name> ...'
      EOF
    end

    def self.register_cli_parser(parser)
      parser.add_cmd('show', ->(cmd, args) { parse_cli(args) })
      parser.add_cmd('s', ->(cmd, args) { parse_cli(args) })
      parser.add_cmd('rshow', ->(cmd, args) { parse_cli(args + ['--raw']) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_script(tokens, opts) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      show_names = false
      opts.filter! do |opt|
        if opt == '--name'
          show_names = true
          false
        else
          true
        end
      end
      ParsedCmd.new(CmdShow.new(args, show_names), opts)
    end

    def self.parse_script(tokens, opts)
      show_names = false
      opts.filter! do |opt|
        if opt == 'name'
          show_names = true
          false
        else
          true
        end
      end
      ParsedCmd.new(CmdShow.new(tokens, show_names), opts)
    end

    def initialize(names, show_names)
      raise Error.new 'show: no names provided' if names.empty?
      @names = names
      @show_names = show_names
    end

    attr_reader :names, :show_names

    def execute(ctx)
      @names.each do |name|
        ename = ctx.expand_name(name)

        pname = show_names ? "#{ename}=" : ''

        if ctx.raw?
          ctx.puts("#{pname}#{ctx.raw_get(ename)}")
        else
          val = ctx.smart_get(ename)
          if val.type == :empty
            ctx.puts("No var with name #{ename}")
          else
            ctx.print(pname)
            val.pretty_print(ctx)
          end
        end
      end
    end
  end
end
