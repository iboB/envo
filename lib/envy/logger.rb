module Envy
  class Logger
    ERROR = 0
    WARN = 1
    INFO = 2
    DEBUG = 3
    def initialize(max_level)
      @max_level = max_level
    end
    attr_accessor :max_level
    def log(level, text)
      return if level > max_level
      stream = level == 0 ? STDERR : STDOUT
      stream.puts(text)
    end
    def plog(level, text)
      return if level > max_level
      stream = level == 0 ? STDERR : STDOUT
      stream.print(text)
    end
    def error(text); log(ERROR, text); end
    def warn(text);  log(WARN,  text); end
    def puts(text);  log(INFO,  text); end
    def print(text); plog(INFO, text); end
    def debug(text); log(DEBUG, text); end
  end
end
