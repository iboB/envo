require_relative '../lib/envy'

include Envy

@host = Host.new(HostShell)
@logger = Logger.new(Logger::INFO)

Commands = [
  CmdShow,
  CmdUnset,
  CmdSet,
  CmdListAdd,
]

module Opts
  extend self
  def parse_cli(opt)
    case opt
    when '--force', '-f' then return {interact: :force}
    when '--no-force', '-nf' then return {interact: :noforce}
    when '--interactive' then return {interact: :interact}
    when '--raw', '-r' then return {raw: true}
    else raise Envy::Error.new "unknown command line option: #{opt}"
    end
  end
end

parser = CliParser.new(Opts)
Commands.each { |cmd| cmd.register_cli_parser(parser) }

parsed = parser.parse(ARGV)

ctx = Context.new(@host, @logger)

ctx.execute(parsed)

puts '======================='

patch = ctx.state.diff

p patch
