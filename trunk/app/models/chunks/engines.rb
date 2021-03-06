$: << File.dirname(__FILE__) + "../../libraries"

require 'redcloth'
require 'bluecloth'
require 'rdocsupport'
require 'chunks/chunk'

# The markup engines are Chunks that call the one of RedCloth, BlueCloth
# or RDoc to convert text. This markup occurs when the chunk is required
# to mask itself.
module Engines
  class AbstractEngine < Chunk::Abstract

    # Create a new chunk for the whole content and replace it with its mask.
    def self.apply_to(content)
      new_chunk = self.new(content)
      content.replace(new_chunk.mask)
    end

    private 

    # Never create engines by constructor - use apply_to instead
    def initialize(content) 
      @content = content
    end

  end
  
 
  class Textile < AbstractEngine
    def mask
      RedCloth.new(@content, @content.options[:engine_opts]).to_html
    end
  end

  class Markdown < AbstractEngine
    def mask
      BlueCloth.new(@content, @content.options[:engine_opts]).to_html
    end
  end

  class RDoc < AbstractEngine
    def mask
      RDocSupport::RDocFormatter.new(@content).to_html
    end
  end

  MAP = { :textile => Textile, :markdown => Markdown, :rdoc => RDoc }
  MAP.default = Textile
end
