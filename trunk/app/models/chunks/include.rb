require 'chunks/wiki'

# Includes the contents of another page for rendering.
# The include command looks like this: "[[!include PageName]]".
# It is a WikiReference since it refers to another page (PageName)
# and the wiki content using this command must be notified
# of changes to that page.
# If the included page could not be found, a warning is displayed.
class Include < WikiChunk::WikiReference
  INCLUDE_PATTERN = /\[\[!include\s+(.*?)\]\](?=\s*)/i
  
  def self.pattern() INCLUDE_PATTERN end

  def initialize(match_data, content)
    super
    @page_name = match_data[1].strip
    @unmask_text = if refpage then
                     if refpage.wiki_includes.include?(@content.page_name)
                       # this will break the recursion
                       @content.delete_chunk(self)
                       refpage.clear_display_cache
                       # raise Instiki::ValidationError.new("Recursive include detected")
                       "<em>Recursive include detected; #{@page_name} --> #{@content.page_name} --> #{@page_name}</em>\n"
                     else 
                       @content.merge_chunks(refpage.display_content)
                       refpage.display_content.pre_rendered 
                     end
                   else
                     "<em>Could not include #{@page_name}</em>\n"
                   end
  end

end
