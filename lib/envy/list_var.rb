module Envy
  class ListVar
    def initialize(name, plat, ar)
      @name = name
      @ar = ar.uniq
    end

    attr_accessor :name

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
  end
end