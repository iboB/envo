module Base
  def a_to_v(a)
    a.join(list_sep)
  end
end


class Win
  extend Base
  def self.list_sep
    ';'
  end
  def self.set(var, value)
    "set #{var}=#{value}"
  end
  def self.unset(var)
    "set #{var}="
  end
end

class Unix
  extend Base
  def self.list_sep
    ':'
  end
  def self.set(var, value)
    "export #{var}=#{value}"
  end
  def self.unset(var)
    "unset -v #{var}"
  end
end

puts Unix.a_to_v(['a', 'b'])
