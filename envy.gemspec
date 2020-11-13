require_relative "lib/envy/version"

Gem::Specification.new do |s|
  s.name = 'envy'
  s.version = Envy::VERSION
  s.date = '2020-11-14'
  s.license = 'MIT'
  s.authors = ['Borislav Stanimirov']
  s.email = 'b.stanimirov@abv.bg'
  s.homepage = 'https://github.com/iboB/envy'
  s.summary = "An environment variable manager"
  s.description = "View, set, unset and manage environment variables (strings, lists, paths) on all platforms."

  s.files = Dir['lib/**/*'] + Dir['bin/*']
  s.executables = ['envy-install', 'envy_run']

  s.post_install_message = <<~MSG
    Thanks for installing envy!
    For this tool to work, you must also run the installation program: 'envy-install'.
    Running it will complete the setup and 'envy' should be available as a command.
  MSG
end
