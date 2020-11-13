# require 'open3'

module Envo
  module Cli
    class InstallerBash
      # def detect_installed_envo?()
      #   stdout, stderr, code = Open3.capture3("bash -ic 'command -v envo'")
      #   code.success?
      # end

      ENVO_INSTALLATION_BEGIN = '### BEGIN envo installation (don\'t remove line)'
      ENVO_INSTALLATION_END = '### END envo installation (don\'t remove line)'

      def find_existing_installation_data(dotfile)
        return nil if !File.exist?(dotfile)

        raise Envo::Error.new "'#{dotfile}' exists but is not a file. You need to choose a file." if !File.file?(dotfile)

        lines = File.readlines(dotfile)
        first = nil
        last = nil
        lines.each_with_index do |l, i|
          lc = l.chomp
          if lc == ENVO_INSTALLATION_BEGIN
            first = i
          elsif lc == ENVO_INSTALLATION_END
            last = i
          end
        end

        return nil if !first && !last

        if !first || !last
          raise Envo::Error.new <<~EOF
            #{dotfile}' contains a broken confy insallation.
            You need to remove it manually
          EOF
        end

        num = last - first + 1
        return {first: first, num: num, lines: lines}
      end

      SOURCE_FILE = 'envo.sh'
      def try_install(dotfile)
        install_lines = [
          ENVO_INSTALLATION_BEGIN,
          "### envo #{VERSION}",
          File.read(File.join(__dir__, SOURCE_FILE)),
          ENVO_INSTALLATION_END
        ]

        found = find_existing_installation_data(dotfile)

        openmode = 'a'
        if found
          lines = found[:lines]
          lines[found[:first], found[:num]] = install_lines
          install_lines = lines
          openmode = 'w'
        end

        File.open(dotfile, openmode) { |f| f.puts install_lines }
        puts <<~EOF
          Sucessfully installed confy to '#{dotfile}'
          Source the file, or restart the bash session if the file is auto-sourced.
        EOF
      end

      def try_uninstall(dotfile)
        found = find_existing_installation_data(dotfile)
        if !found || found[:num] == 0
          raise Envo::Error.new "'#{dotfile}' doesn't seem to contain an envo installation"
        end

        lines = found[:lines]
        lines[found[:first], found[:num]] = []
        File.open(dotfile, 'w') { |f| f.puts lines }
        puts "Suncessfully uninstalled confy from '#{dotfile}'"
      end

      DEFAULT_DOTFILE = File.join(Dir.home, '.bashrc')
      USAGE = <<~EOF
        usage: envo-install [u] [--dotfile <path>]
      EOF
      def run(argv)
        if argv.empty?
          try_install(DEFAULT_DOTFILE)
          return 0
        end

        if argv[0] == '--help' || argv[0] == '-?'
          puts "installer for envo v#{Envo::VERSION} #{Envo::VERSION_TYPE}"
          puts USAGE
          puts
          puts '                u - uninstall envo'
          puts ' --dotfile <file> - install to or uninstall form a specified dotfile'
          return 0
        end

        if argv[0] == 'u'
          @uninstalling = true
          argv.shift
        end

        dotfile = DEFAULT_DOTFILE
        if !argv.empty?
          arg = argv.shift
          if arg != '--dotfile'
            STDERR.puts "Unknown argument #{arg}"
            STDERR.puts USAGE
            return 1
          end
          if argv.empty?
            STDERR.puts "Missing dotfile path"
            STDERR.puts USAGE
            return 1
          end
          dotfile = argv.shift
        end

        # if detect_installed_envo?
        #   puts "It seems that you already have envo installed"
        #   puts "Do you want to reinstall it? (y/n)"
        # end
        @uninstalling ? try_uninstall(dotfile) : try_install(dotfile)
        return 0
      end
    end
  end
end
