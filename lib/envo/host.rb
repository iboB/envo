module Envo
  class Host
    def initialize(shell)
      @shell = shell
    end
    attr_reader :shell

    def env
      ENV
    end

    def pwd
      Dir.pwd
    end

    def home
      Dir.home
    end

    def path_exists?(path)
      File.exist?(path)
    end

    def path_id(path)
      return -1 if !File.exist?(path)
      File.stat(path).ino
    end
  end
end
