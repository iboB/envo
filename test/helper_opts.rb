module HelperOpts
  extend self
  def parse_cli(opt)
    case opt
    when '--foo', '-f' then return :foo, true
    when '--bar', '-b' then return :bar, true
    when '--baz', '-z' then return :baz, true
    else raise Envy::Error.new opt
    end
  end
end
