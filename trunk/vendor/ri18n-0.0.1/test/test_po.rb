
require 'test/unit'
require 'ri18n/po'



class PoSourceTest < Test::Unit::TestCase
  
  P1 = <<PO_END
msgid "one"
msgstr "un"
PO_END
  E1 = {'one' => 'un'}
  P2 = P1 + <<PO_END
 
msgid "two"
msgstr "deux"
PO_END
  E2 = {'one' => 'un', 'two' => 'deux'}
  
  P3 = <<PO_END + P1
#  translator-comments
#. automatic-comments
#: reference...
#, flag...
PO_END
  E3 = E1
  
def test_parse_one
    assert_equal(E1, PoSource.new(P1).parse )
    assert_equal(E1, PoSource.new(P1 + "\n").parse )
    assert_equal(E1, PoSource.new(P1 + "\n\n").parse )
  end
  
  def test_parse_two
    assert_equal(E2, PoSource.new(P2).parse )
    assert_equal(E2, PoSource.new(P2+ "\n").parse )
    assert_equal(E2, PoSource.new(P2+ "\n\n").parse )
  end
  
  def test_parse_with_comment
    p3 = PoSource.new(P3).parse
    assert_equal(E3, p3)
    
    assert_respond_to(p3['one'], :comments)
    assert_equal(['#  translator-comments', 
                  '#. automatic-comments',
                  '#: reference...',
                  '#, flag...'], p3['one'].comments)
    
  end
  
end
