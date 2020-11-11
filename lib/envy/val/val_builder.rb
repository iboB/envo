# perhaps too little for a class?
module Envy
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

    def from_user_text
    end
  end
end
