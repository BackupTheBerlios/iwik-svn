require 'i18nservice'

class  Hash
  
  def po_format
    ret = ''
    each{|id, str| ret << "msgid \"#{id}\"\nmsgstr \"#{str}\"\n\n"}
    ret
  end

end

class String
  def interpolate(b)
    eval('"' + self + '"', b)
  end
end

class Object
  def getBinding
    binding
  end
end