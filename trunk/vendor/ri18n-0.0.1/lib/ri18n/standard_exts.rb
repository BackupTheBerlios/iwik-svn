
class String
  def interpolate(b)
    eval('"' + self + '"', b)
  end
  
# strip and unquote
  def strip_q
    strip[1..-2]
  end
  
  def strip_q!
    strip!
    slice!(0)
    slice!(-1)
  end
end

class Object
  def getBinding
    binding
  end
end