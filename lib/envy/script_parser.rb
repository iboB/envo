require 'csv'

module Envy
  class ScriptParser
    def initialize(opts)
      @known_cmds = {}
      @known_opts = opts
    end
    def add_cmd(name, parse_func)
      raise Envy::Error "cmd #{name} is already added to parser" if @known_cmds[name]
      @known_cmds[name] = parse_func
    end
    def parse(lines)
      result = ParseResult.new

      lines.each_with_index do |line, li|
        li += 1
        line.strip!
        next if line.empty?
        next if line[0] == '#' # comment

        line_opts = if line[0] == '{' # opts pack
          i = line.index('}')
          raise Envy::Error.new "#{li}: malformed options pack" if !i
          opts = line[1...i].split(',')
          line = line[i+1..]
          opts
        else
          []
        end

        raise Envy::Error.new "#{li}: missing command" if line.empty?

        tokens = []
        begin
          tokens = CSV::parse_line(line, col_sep: ' ').compact
        rescue
          puts "AAAAAAA: #{line.inspect}"
          raise Envy::Error.new "#{li}: malformed line"
        end

        raise Envy::Error.new "#{li}: missing command" if tokens.empty?
        cmd = tokens.shift
        raise Envy::Error.new "#{li}: unknown command '#{cmd}'" if !@known_cmds[cmd]
        parsed_cmd = @known_cmds[cmd].(cmd, tokens, line_opts)

        cmd_opts = {}
        parsed_cmd.opts.each do |opt|
          cmd_opts.merge! @known_opts.parse_script(opt)
        end
        parsed_cmd.opts = cmd_opts

        result.cmds << parsed_cmd
      end
      result
    end
  end
end
