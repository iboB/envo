module Envy
  class VarBuilder
    def self.build(sys, name, str)
      return NoVar.new(sys, name) if !str

      plat = sys.platform
      is_list = plat.likely_list?(str)
      is_path = plat.likely_abs_path?(str)

      if is_list
        ar = plat.v_to_a(str)
        if is_path
          return AbsPathListVar.new(sys, name, ar)
        else
          return ListVar.new(sys, name, ar)
        end
      elsif is_path
        return AbsPathVar.new(sys, name, str)
      else
        return StringVar.new(sys, name, str)
      end
    end
  end
end
