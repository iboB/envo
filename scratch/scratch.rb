require_relative '../lib/envo'

include Envo

@host = Host.new(HostShell)
@logger = Logger.new

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
    else raise Envo::Error.new "unknown command line option: #{opt}"
    end
  end
  Defaults = {
    interact: :interact,
    log_level: Logger::INFO
  }
end

parser = CliParser.new(Opts)
Commands.each { |cmd| cmd.register_cli_parser(parser) }

parsed = parser.parse(ARGV)

ctx = Context.new(@host, @logger, Opts::Defaults)

ctx.execute(parsed)

puts '======================='

patch = ctx.state.diff

p patch
