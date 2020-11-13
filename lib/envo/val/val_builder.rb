require 'pathname'

module Envo
  module ValBuilder
    extend self

    def from_env_string(str, host)
      return NoVal.new if !str

      is_list = host.shell.likely_list?(str)
      is_path = host.shell.likely_abs_path?(str)

      if is_list
        ar = host.shell.list_to_ar(str)
        if is_path
          return PathListVal.new(host, ar)
        else
          return ListVal.new(ar)
        end
      elsif is_path
        return PathVal.new(host, str)
      else
        return StringVal.new(str)
      end
    end

    def from_user_string(str, host)
      if host.shell.likely_abs_path?(str)
        return PathVal.new(host, host.shell.fix_path(str))
      end

      if host.shell.likely_rel_path?(str)
        # the pathname approach is not multi-platform
        # ie windows paths won't work on non-windows host
        # we should reimplement pathname joins for windows for this to work
        path = Pathname.new host.pwd
        path += str
        return PathVal.new(host, host.shell.fix_path(path.cleanpath.to_s))
      end

      return StringVal.new str
    end

    def from_user_text(text, host)
      return from_user_string(text, host) if text.class != Array
      return NoVal.new if text.empty?

      elems = text.map { |str| from_user_string(str, host) }

      # array of 1 is as good as nothing
      return elems[0] if elems.size == 1

      is_path = elems[0].type == :path
      elems.map! { |elem| elem.to_s }

      return is_path ? PathListVal.new(host, elems) : ListVal.new(elems)
    end
  end
end
