module Envo
  class PathListVal < ListVal
    def initialize(host, ar)
      super(ar)
      @host = host
    end
    def type
      :"path list"
    end
    def accept_assign?(other)
      other.type == type
    end
    def accept_item?(item)
      item.type == :path
    end

    def make_helper_map
      @ar.map { |p|
        id = @host.path_id(p)
        { str: p, id: id }
      }
    end

    def pretty_print(ctx)
      helper = make_helper_map

      ctx.puts "["
      helper.each_with_index do |v, i|
        dupes = helper.count { |e|
          if e[:str] == v[:str] then true
          elsif e[:id] == -1 then false
          else e[:id] == v[:id]
          end
        }
        str = dupes > 1 ? 'D' : ' '
        str += v[:id] != -1 ? ' ' : 'N'
        str += ' '
        str += "#{i}:".ljust(4)
        str += v[:str]
        ctx.puts str
      end
      ctx.puts ']'
    end

    def clean!
      helper = make_helper_map
      helper.select! { |e| e[:id] != -1 }
      helper.uniq! { |e| e[:id] }
      @ar = helper.map { |e| e[:str] }
    end
  end
end
