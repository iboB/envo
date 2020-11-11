# perhaps too little for a class?
module Envy
  class ValBuilder
    def self.from_env_string(str, sys, shell)
      return NoVal.new if !str

      is_list = shell.likely_list?(str)
      is_path = shell.likely_abs_path?(str)

      if is_list
        ar = shell.list_to_ar(str)
        if is_path
          return PathListVal.new(sys, ar)
        else
          return ListVal.new(ar)
        end
      elsif is_path
        return PathVal.new(sys, str)
      else
        return StringVal.new(str)
      end
    end
  end
end
