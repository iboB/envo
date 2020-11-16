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

    def pretty_print(ctx)
      dd = @ar.map { |p|
        id = @host.path_id(p)
        { str: p, id: id }
      }

      ctx.puts "["
      dd.each_with_index do |v, i|
        dupes = dd.count { |e|
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
      super
      @ar.select! { |s| @host.path_exists?(s) }
    end
  end
end
