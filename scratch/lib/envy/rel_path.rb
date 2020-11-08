module Envy
  class RelPath
    def initialize(str)
      @str = str
    end

    def envy_to_s(sys)
      sys.platform.fix_path(File.join(sys.pwd, @str))
    end
  end
end
