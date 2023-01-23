require_relative "lib/envo/version"

Gem::Specification.new do |s|
  s.name = 'envo'
  s.version = Envo::VERSION
  s.date = '2023-01-24'
  s.license = 'MIT'
  s.authors = ['Borislav Stanimirov']
  s.email = 'b.stanimirov@abv.bg'
  s.homepage = 'https://github.com/iboB/envo'
  s.summary = "A CLI environment variable manager"
  s.description = <<~DESC
    A CLI environment variable manager.
    View, set, unset and manage environment variables (strings, lists, paths) on bash and on cmd.
  DESC

  s.files = Dir['lib/**/*'] + Dir['bin/*'] + ['LICENSE', 'README.md']
  s.executables = ['envo-install', 'envo_run']

  s.post_install_message = <<~MSG
    Thanks for installing envo v#{Envo::VERSION} #{Envo::VERSION_TYPE}!
    For the tool to work you must also run the installation program:
    $ envo-install
    Running it will complete the setup and 'envo' should be available as a command.
    For help run:
    $ envo --help
  MSG
end
