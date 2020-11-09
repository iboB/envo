require_relative '../lib/envy'

puts Envy::VERSION
puts Envy::VERSION_TYPE

s = Envy::CmdSet.parse_cmd_line ""

p s
