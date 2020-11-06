require_relative '../lib/envy'

io = Envy::Platform::Windows.make_io

io.puts("Hello world")

ARGV.each do |arg|
    io.puts(arg)
end

# io.set_env_var("xxx", "yyy")

STDERR.puts('error')

puts io.output

exit 3

