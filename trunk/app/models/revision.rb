require 'diff'
require 'wiki_content'
require 'chunks/wiki'
require 'date'
require 'author'
require 'page'

class Revision

  attr_accessor :page, :number, :content, :created_at, :author

  def initialize(page, number, content, created_at, author)
    @page, @number, @created_at, @author = page, number, created_at, author
    self.content = content
    @display_cache = nil
  end

  def created_on
    Date.new(@created_at.year, @created_at.mon, @created_at.day)
  end

  def pretty_created_at
    # Must use DateTime because Time doesn't support %e on at least some platforms
    DateTime.new(
      @created_at.year, @created_at.mon, @created_at.day, @created_at.hour, @created_at.min
    ).strftime "%B %e, %Y %H:%M" 
  end

  def next_revision
    page.revisions[number + 1]
  end

  def previous_revision
    number > 0 ? page.revisions[number - 1] : nil
  end

  # Returns an array of all the WikiIncludes present in the content of this revision.
  def wiki_includes
    unless @wiki_includes_cache 
      chunks = display_content.find_chunks(Include)
      @wiki_includes_cache = chunks.map{ |c| ( c.escaped? ? nil : c.page_name ) }.compact.uniq
    end
    @wiki_includes_cache
  end  

  # Returns an array of all the WikiReferences present in the content of this revision.
  def wiki_references
    unless @wiki_references_cache 
      chunks = display_content.find_chunks(WikiChunk::WikiReference)
      @wiki_references_cache = chunks.map { |c| ( c.escaped? ? nil : c.page_name ) }.compact.uniq
    end
    @wiki_references_cache
  end  
  
  # Returns an array of all the WikiLinks present in the content of this revision.
  def wiki_links
    unless @wiki_links_cache 
      wiki_chunks = display_content.find_chunks(WikiChunk::WikiLink)
      @wiki_links_cache = wiki_chunks.map { |c| ( c.escaped? ? nil : c.page_name ) }.compact.uniq
    end
    @wiki_links_cache
  end  

  # Returns an array of all the WikiLinks present in the content of this revision.
  # that already exists as a page in the web.
  def existing_pages
    wiki_links.select { |wiki_link| page.web.pages[wiki_link] }
  end

  # Returns an array of all the WikiLinks present in the content of this revision
  # that *doesn't* already exists as a page in the web.
  def unexisting_pages
    wiki_links - existing_pages
  end  

  # Explicit check for new type of display cache with chunks_by_type method.
  # Ensures new version works with older snapshots.
  def display_content
    unless @display_cache && @display_cache.respond_to?(:chunks_by_type)
      @display_cache = WikiContent.new(self)
      @display_cache.render!
    end
    @display_cache
  end

  def display_diff
    previous_revision ? HTMLDiff.diff(previous_revision.display_content, display_content) : display_content
  end

  def clear_display_cache
    @display_cache = @published_cache = @wiki_links_cache = nil
    @wiki_references_cache = @wiki_includes_cache = nil
  end

  def display_published
    unless @published_cache && @published_cache.respond_to?(:chunks_by_type)
      @published_cache = WikiContent.new(self, {:mode => :publish})
      @published_cache.render!
    end
    @published_cache
  end

  def display_content_for_export
    WikiContent.new(self, {:mode => :export} ).render!
  end
  
  def force_rendering
    begin
      display_content.render!
    rescue Exception => e
      ApplicationController.logger.error "Failed rendering page #{@name}"
      ApplicationController.logger.error e
      message = e.message.gsub(/\n/, '<br/>')
      # substitute content with an error message
      content = <<-EOL
          <p>Markup engine has failed to render this page, raising the following error:</p>
          <p>#{message}</p>
      EOL
      raise e
    end
  end

end
