require 'test/unit'
require 'ri18n/standard_exts'

class StringInterpolateTest < Test::Unit::TestCase
  
  def test_unchanged
    string = 'blah'
    assert_equal string, string.interpolate(binding)
  end
  
  def test_simple
    @color = 'red'
    string = 'the horse is #{@color}'
    assert_equal 'the horse is red', string.interpolate(binding)
    
    @color = 'blue'
    assert_equal 'the horse is blue', string.interpolate(binding)
  end
end

class StringStrip_qTest < Test::Unit::TestCase

  def test_strip_q
    assert_equal 'blah bla bla  ', '   "blah bla bla  " '.strip_q
  end
  
  def test_strip_q!
    s = '   "blah bla bla  " '
    s.strip_q!
    assert_equal 'blah bla bla  ', s
  end

# TODO: make this work (even if it is not needed in the code for now)
  def _test_strip_q_incomplete
    assert_equal 'blah bla bla', '   "blah bla bla '.strip_q
  end

end