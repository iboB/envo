module Envo
  class CmdListDel
    def self.register_help(help)
      help.add_cmd 'ld <name> <val|index>', "shorthand for 'list <name> del <val|index>'"
    end

    def self.register_cli_parser(parser)
      parser.add_cmd('ld', ->(cmd, args) { parse_cli_all(args) })
    end

    def self.register_script_parser(parser)
    end

    def self.parse_cli_all(args)
      opts = CliParser.filter_opts_front(args)
      raise Envo::Error.new "list-del: missing name. Use 'ld <name> <val|index>'" if args.empty?
      parse_cli_args(args[0], args[1..], opts)
    end

    def self.parse_cli_args(name, args, opts)
      opts += CliParser.filter_opts(args)
      parse_tokens(name, args, opts)
    end

    def self.parse_tokens(name, tokens, opts)
      raise Envo::Error.new "list-del: provide one value or index to delete. Use 'list <name> del <val|index>'" if tokens.size != 1
      ParsedCmd.new(CmdListDel.new(name, tokens[0]), opts)
    end

    def initialize(name, value)
      @name = name
      @value = value
    end

    attr_accessor :name, :value

    def execute(ctx)
      ename = ctx.expand_name(@name)

      list = ctx.smart_get(ename)

      if list.type == :empty
        return if ctx.force?
        raise Envo::Error.new "list-del: deleting an item from a non-exiting value"
      end

      ok = list.list?
      ok ||= ctx.ask("#{ename} is not a list, but a #{list.type}. Convert?")
      raise Envo::Error.new "list-del: deleting an item from a non-list" if !ok

      list = list.to_list

      val = ctx.expand_value(@value)
      if val.list?
        raise Envo::Error.new "list-del: can't delete a list from a list" if !ctx.force?
        return
      end
      val = val.to_s

      index = val.to_i
      if !ctx.raw? && index.to_s == val
        deleted = list.delete_at(index)
        if !deleted
          raise Envo::Error.new "list-del: no index #{val} in #{ename}" if !ctx.force?
          return
        end
      else
        deleted = list.delete(val)
        if !deleted
          raise Envo::Error.new "list-del: no item '#{val}' in #{ename}" if !deleted
          return
        end
      end

      ctx.smart_set(ename, list)
    end
  end
end
