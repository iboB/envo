require_relative "lib/envy/version"

Gem::Specification.new do |s|
  s.name = 'envy'
  s.version = Envy::VERSION
  s.date = '2020-11-4'
  s.license = 'MIT'
  s.authors = ['Borislav Stanimirov']
  s.email = 'b.stanimirov@abv.bg'
  s.homepage = 'https://github.com/iboB/envy'
  s.summary = "An environment variable manager"
  s.description = <<-DESC
View, set, unset and manage environment variables (strings, lists, paths) on
all platforms.
  DESC

  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
end
