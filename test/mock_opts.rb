module MockOpts
  extend self
  def parse_cli(opt)
    case opt
    when '--foo', '-f' then return {foo: true}
    when '--bar', '-b' then return {bar: true}
    when '--baz', '-z' then return {baz: true}
    when '--raw' then return {raw: true}
    else raise Envo::Error.new opt
    end
  end
  def parse_script(opt)
    case opt
    when 'foo' then return {foo: true}
    when 'bar' then return {bar: true}
    when 'baz' then return {baz: true}
    when 'raw' then return {raw: true}
    else raise Envo::Error.new opt
    end
  end
end
