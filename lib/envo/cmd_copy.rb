module Envo
  class CmdCopy
    Name = 'copy'
    def self.register_help(help)
      help.add_cmd 'copy <source-name> <target-name>', <<~EOF
        copy value of source to target
          shorthand: 'cp'
      EOF
    end

    def self.register_cli_parser(parser)
      parser.add_cmd(Name, ->(cmd, args) { parse_cli(args) })
      parser.add_cmd('cp', ->(cmd, args) { parse_cli(args) })
    end

    def self.register_script_parser(parser)
      parser.add_cmd(Name, ->(cmd, tokens, opts) { parse_tokens(tokens, opts) })
    end

    def self.parse_cli(args)
      opts = CliParser.filter_opts(args)
      parse_tokens(args, opts)
    end

    def self.parse_tokens(tokens, opts)
      raise Envo::Error.new "copy: provide two names to copy. Use 'copy <source-name> <target-name>'" if tokens.size != 2
      ParsedCmd.new(CmdCopy.new(tokens[0], tokens[1]), opts)
    end

    def initialize(source, target)
      @source = source
      @target = target
    end

    attr_accessor :source, :target

    def execute(ctx)
      esrc = ctx.expand_name(@source)
      raw_src = ctx.raw_get(esrc)
      raise Envo::Error.new "copy: no such var '#{esrc}'" if !raw_src && !ctx.force?
      return if !raw_src

      etarget = ctx.expand_name(@target)
      raw_target = ctx.raw_get(etarget)

      ok = !raw_target
      ok ||= ctx.ask("'#{etarget}' already exists. Overwrite?")
      raise Envo::Error.new "'#{etarget}' exists" if !ok

      return if esrc == etarget # copy something over itself...
      return if !raw_src && !raw_target # no point in doing anything if they don't exist

      ctx.raw_set(etarget, raw_src)
    end
  end
end
