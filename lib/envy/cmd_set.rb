module Envy
  class CmdSet
    Name = 'set'
    def self.register_help(ctx)
      ctx.help.add_cmd(Name, "set stuff")
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cmd_line(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_script(args) })
    end

    def self.parse_cmd_line(args)
      puts "#{Name} parse_cmd_line"
    end

    def self.parse_script(args)
      puts "#{Name} parse_script"
    end

    def execute(ctx)
      ename = ctx.expand_name(@name)
      evalue = ctx.expand_value(@value)

      if opts[:force]
        ctx.set(ename, evalue)
      else
        old_val = ctx.smart_get(ename)
        if old_val.accept_assign?(evalue)
          ctx.set(ename, evalue)
        else
          if ctx.ask("Assign #{evalue.type} to #{old_val.type}?")
            ctx.set(ename, evalue)
          else
            raise Envy::Error.new "Assignment of #{evalue.type} to #{old_val.type}"
          end
        end
      end
    end
  end
end
