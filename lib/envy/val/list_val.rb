module Envy
    class ListVal
      def initialize(ar)
        @ar = ar
      end
      attr_accessor :ar

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
      def uniq!
        @ar.uniq!
      end
      def clean!
        uniq!
      end
      def shift(elem, dir)
        i = @ar.index(elem)
        return nil if i == nil
        shift_at(i, dir)
      end
      def shift_at(i, dir)
        return nil if i>@ar.size

        if dir == :front
          return i if i == 0
          elem = ar[i]
          @ar.delete_at i
          @ar.unshift(elem)
          0
        elsif dir == :back
          return i if i == (@ar.size-1)
          elem = ar[i]
          @ar.delete_at i
          @ar << elem
          @ar.size-1
        elsif dir == :up
          return i if i == 0
          @ar[i-1], @ar[i] = @ar[i], @ar[i-1]
          i - 1
        elsif dir == :down
          return i if i == (@ar.size-1)
          @ar[i+1], @ar[i] = @ar[i], @ar[i+1]
          i + 1
        else
          -1
        end
      end

      # def attribs(elem)
      #   @ar.count(elem) > 1 ? 'D' : ' '
      # end
      # def pretty_print(io)
      #   io.puts "#{name}=["
      #   @ar.each_with_index do |v, i|
      #     str = attribs(v) + ' '
      #     str += "#{i}:".ljust(4)
      #     str += v
      #     io.puts(str)
      #   end
      #   io.puts ']'
      # end
      # def interactive_to_list(io)
      #   return self
      # end
    end
  end
