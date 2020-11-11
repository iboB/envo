class MockCtx
  def initialize
    reset
  end

  def reset
    @sets = {}
    @unsets = []
    @interactivity = :interactive
    @questions = []
    @answers = nil
    @log = []
    @raw = false
  end

  def error(text); @log << 'e:' + text; end
  def warn(text);  @log << 'w:' + text; end
  def print(text); @log << 'p:' + text; end
  def puts(text);  @log << 'i:' + text; end
  def debug(text); @log << 'd:' + text; end

  attr_accessor :sets, :unsets
  attr_accessor :interactivity, :questions, :answers
  attr_accessor :raw
  attr_accessor :log

  def raw?; @raw; end

  class MockSys
    def self.path_exists?(path)
      false
    end
  end
  def sys
    MockSys
  end

  def expand_name(name)
    name
  end
  def expand_value(val)
    val
  end

  def smart_get(name)
    case name
    when /^str/ then StringVal.new(name)
    when /^list/ then ListVal.new(['val', name])
    when /^path/ then PathVal.new(MockSys, '/xx/yy/' + name)
    when /^plist/ then PathListVal.new(MockSys, ['/zz/ww', '/aa/bb/' + name])
    else NoVal.new
    end
  end
  def smart_set(name, val)
    @sets[name] = val
  end
  def raw_get(name)
    case name
    when /^str/ then name
    when /^list/ then 'val:' + name
    when /^path/ then '/xx/yy/' + name
    when /^plist/ then '/zz/ww:/aa/bb/' + name
    else nil
    end
  end
  def unset(name)
    @unsets << name
  end

  def force?
    @interactivity == :force
  end
  def no_force?
    @interactivity == :no_force
  end
  def interactive?
    @interactivity == :interactive
  end
  def ask(q)
    if interactive?
      questions << q
      answers.shift
    else
      force?
    end
  end
end
