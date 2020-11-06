require_relative '../lib/envy'

io = Envy::HostSystem.platform.make_io

io.puts("Hello world")

ARGV.each do |arg|
    io.puts(arg)
end

io.set_env_var("zzz", "my value")
io.set_env_var("z00", "A>5")

STDERR.puts('error')

puts io.output

exit 3

