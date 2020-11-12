module Envy
  class PathVal
    def initialize(host, str)
      @host = host
      @path = str
    end
    attr_reader :host
    attr_accessor :path
    # casts
    def type
      :path
    end
    def accept_assign?(other)
      other.type == type
    end
    def invalid_description
      @host.path_exists?(@path) ? nil : 'non-existing path'
    end
    def list?
      false
    end
    def to_list
      return PathListVal.new(@host, [@path])
    end
    def to_s
      @path
    end
    def pretty_print(ctx)
      ctx.puts @path
      inv = invalid_description
      return if !inv
      ctx.warn "Warning: #{inv}"
    end
    def to_env_s
      @path
    end
  end
end
