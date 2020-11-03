

class Win
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

puts Unix.set('a', 'b')
