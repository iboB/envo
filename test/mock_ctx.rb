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

  class MockHost
    def self.path_exists?(path)
      path == '/this/path/exists'
    end
    def self.path_id(path)
      path_exists?(path) ? path.hash : -1
    end
  end
  def host
    MockHost
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
    when /^path/ then PathVal.new(MockHost, '/xx/yy/' + name)
    when /^plist/ then PathListVal.new(MockHost, ['/zz/ww', '/aa/bb/' + name])
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
  def raw_set(name, val)
    @sets[name] = val
  end
  def unset(name)
    @unsets << name
  end

  def force?
    @interactivity == :force
  end
  def noforce?
    @interactivity == :noforce
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
