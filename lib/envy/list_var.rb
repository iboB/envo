module Envy
  class ListVar
    def initialize(name, plat, ar)
      @name = name
      @platform = plat
      @ar = ar
    end
    attr_accessor :name
    def to_env_val
      return nil if @ar.empty
      @platform.a_to_v(@ar)
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
    def ar
      @ar.clone
    end
    def uniq!
      @ar.uniq!
      return self
    end
  end
end