require 'chunks/chunk'


class BorkChunk < Chunk::Abstract
  
  BORK_PATTERN = Chunk::Abstract.mask_re(Chunk::Abstract::derivatives)
  
  def self.pattern() BORK_PATTERN  end


	def initialize(match_data, content) 
          super
	  @unmask_text = @text 
        end
  

end
 
