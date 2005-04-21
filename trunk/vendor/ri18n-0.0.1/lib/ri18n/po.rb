require 'ri18n/msg'

class  Array
  
  def pot_format(nplurals)
    ret = ''
    each{|x| 
      ret << x.pot_format(nplurals)
}
    ret
  end

end

class  Hash
  
  def po_format(nplurals)
    ret = ''
    each{|id, str| 
      if str.respond_to? :po_format
        ret << str.po_format(id, nplurals)
      else
        ret << Msg.new(str.to_s, nil).po_format(id, nplurals)
      end
    }
    ret
  end 

end

class PoSource < String
  ENTRY_SEP = /(?:\n\n)|(?:\n \n)/m
  def parse
    @table = {}
    self.split(ENTRY_SEP).each{|entry|
      next if entry.strip.empty?
      id, msg = Msg::Parse(entry)
      @table[id] = msg
    }
		parse_header
    @table
  end

	def parse_header
		return unless @table.has_key?(nil)
		@table[nil]
	end
end
