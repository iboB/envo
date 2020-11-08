module Envy
  class ScriptRunner
    def initialize(sys)
      @sys = sys
    end

    def find_script(fname)
      return File.file?(fname) && fname if @sys.platform.likely_abs_path?(fname)

      dir = Dir.pwd

      check = File.join(dir, fname)
      return check if File.file?(check)

      while true
        check = File.join(dir, '.envy', fname)
        return check if File.file?(check)
        new_dir = File.dirname(dir)
        break if new_dir == dir
        dir = new_dir
      end

      check = File.join(@sys.home_dir, '.envy', fname)
      return check if File.file?(check)

      return false
    end

    def run_script(io, fname)
      builder = Builder.new(@sys)

      File.readlines(fname).each do |line|
      end

      p builder.diff
    end
  end
end

