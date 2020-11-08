module Envy
  class ListVar
    def initialize(sys, name, ar)
      @sys = sys
      @name = name
      @ar = ar
    end
    attr_accessor :name
    def to_env_val
      return nil if @ar.empty?
      @sys.platform.a_to_v(@ar)
    end
    def insert(elem, pos = nil)
      # assume unique elements
      old_index = @ar.index(elem)
      new_index = case pos
        when :front then 0
        when :back then -1
        else old_index
      end

      return @ar << elem if !new_index
      return @ar if new_index == old_index
      return @ar.insert(new_index, elem) if !old_index

      # we need to reorder
      @ar.delete_at(old_index)
      @ar.insert(new_index, elem)
    end
    def delete(elem)
      @ar.delete(elem)
    end
    def delete_at(index)
      @ar.delete_at(index)
    end
    def ar
      @ar.clone
    end
    def uniq!
      @ar.uniq!
      return self
    end
    def clean!
      uniq!
    end

    def attribs(elem)
      @ar.count(elem) > 1 ? 'D' : ' '
    end
    def pretty_print(io)
      io.puts "#{name}=["
      @ar.each_with_index do |v, i|
        str = attribs(v) + ' '
        str += "#{i}:".ljust(4)
        str += v
        io.puts(str)
      end
      io.puts ']'
    end
    def interactive_to_list(io)
      return self
    end
  end
end
