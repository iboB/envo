class HelperCtx
  def initialize(env = nil)
    @fake_env = env || {
      'PATH' => 'foo',
      'foo' => 'bar',
      'something' => 'other'
    }
  end

  attr_accessor :interactivity, :fake_env

  def expand_name(name)
    name
  end

  def raw_get(name)
    fake_env[name]
  end

  def unset(name)
    fake_env.delete(name)
  end

  def force?
    @interactivity == :force
  end
  def interactive?
    @interactivity == :interactive
  end
  def no_force?
    @interactivity == :no_force
  end
end
