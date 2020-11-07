module Envy
  class AbsPathListVar < ListVar
    def initialize(sys, name, ar)
      super(sys.platform, name, ar)
      @ar = ar.map { |path| AbsPathVar.new(sys, nil, path) }
    end
    attr_accessor :name
    def to_env_val
      return nil if @ar.empty
      @platform.a_to_v(@ar.map { |path| path.value })
    end
    def pretty_print(io)
      io.puts "#{name}=["
      @ar.each_with_index do |v, i|
        str = @ar.count(v) > 1 ? 'D' : ' '
        str += v.exist? ? '  ' : 'N '
        str += "#{i}:".ljust(4)
        str += v.value
        io.puts(str)
      end
      io.puts ']'
    end
  end
end
