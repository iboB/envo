module Envy
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

    def path_exists?(path)
      File.exist?(path)
    end
  end
end
