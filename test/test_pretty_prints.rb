require_relative '../lib/envo'
require_relative 'mock_ctx'
require 'test/unit'

include Envo

class TestPrettyPrints < Test::Unit::TestCase
  def test_no_val
    ctx = MockCtx.new
    nv = NoVal.new
    nv.pretty_print(ctx)

    assert_equal ctx.log, ['i:<empty>']
  end

  def test_string_val
    ctx = MockCtx.new
    sv = StringVal.new('asdf')
    sv.pretty_print(ctx)
    assert_equal ctx.log, ['i:asdf']

    ctx.reset
    sv.value = ''
    sv.pretty_print(ctx)
    assert_equal ctx.log, ['i:', 'w:Warning: empty string']
  end

  def test_path_val
    ctx = MockCtx.new
    pv = PathVal.new(ctx.host, '/this/path/exists')
    pv.pretty_print(ctx)
    assert_equal ctx.log, ['i:/this/path/exists']

    ctx.reset
    pv.path = '/other/path'
    pv.pretty_print(ctx)
    assert_equal ctx.log, ['i:/other/path', 'w:Warning: non-existing path']
  end

  def test_list_val
    ctx = MockCtx.new
    lv = ListVal.new(['a', 'b', 'a', 'c'])
    lv.pretty_print(ctx)

    assert_equal ctx.log, [
      'i:[',
      'i:D 0:  a',
      'i:  1:  b',
      'i:D 2:  a',
      'i:  3:  c',
      'i:]'
    ]
  end

  def test_path_list_val
    ctx = MockCtx.new
    plv = PathListVal.new(ctx.host, ['/this/path/exists', '/other', '/third', '/other'])
    plv.pretty_print(ctx)

    assert_equal ctx.log, [
      'i:[',
      'i:   0:  /this/path/exists',
      'i:DN 1:  /other',
      'i: N 2:  /third',
      'i:DN 3:  /other',
      'i:]'
    ]
  end
end
