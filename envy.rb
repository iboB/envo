ARGS = {}

VERSION = "1.0.2"

VERSION_TEXT = "envy v#{VERSION}"

USAGE = <<ENDUSAGE
Usage:
    envy [--quiet] [--verbose] <command> args
ENDUSAGE

HELP = <<ENDHELP
    help
ENDHELP

cmd_index = ARGV.each_with_index do |arg, index|
  case arg
    when '-h', '--help', 'help' then ARGS[:help] = true
    when '-v', '--version'      then ARGS[:ver] = true
    when '-q', '--quiet'        then ARGS[:quiet] = true
    when '-V', '--verbose'      then ARGS[:verbose] = true
    else break index
  end
end

def log(text, level = 0)
  return if ARGS[:quiet]
  return if level > 0 && !ARGS[:verbose]
  puts text
end

if ARGS[:ver]
  log VERSION_TEXT
  exit
end

if ARGS[:help]
  log VERSION_TEXT
  log USAGE
  log HELP
  exit
end

if cmd_index.instance_of? Array
  log USAGE
  exit
end

cmd = ARGV[cmd_index]
cmd_args = ARGV[cmd_index+1..-1]

if cmd == 'pl'
  path = ENV['path']
  log path.split(';')
else
  log "Unknown command #{cmd}"
  log HELP
  exit 1
end
