#!/bin/env ruby 

require File.dirname(__FILE__) + '/../test_helper'

require 'web'
require 'page'
require 'revision'
require 'wiki_content'

class WikiContentTest < Test::Unit::TestCase
  
  def setup
    @s = WikiServiceWithNoPersistence.new
    @s.create_web 'Instiki', 'instiki'
    @web = @s.webs['instiki']

    @web.markup = :textile
    @t =  Time.local(2004, 4, 4, 16, 50)
    @a =  "DavidHeinemeierHansson"
    
    @web.add_page("FirstPage", "FirstPage content text", @t, @a)
    @page = @web.pages["FirstPage"]
    
    @web.add_page("IncludedPage", 
         "autolink.fr @IncludedPage@ content text <nowiki>HeyWord [[blah]]</nowiki>", @t, @a)
    @include_page = @web.pages["IncludedPage"]
  end

  def teardown
    @s.delete_web 'instiki'
  end
  

  def wc(string)
    @revision = Revision.new(@page, 1, string, @t, @a)
    ret = WikiContent.new(@revision)
    ret.render!
  end

  def ws(string)
    @revision = Revision.new(@page, 1, string, @t, @a)
    WikiContent.new(@revision)
  end

  def test_textile_wikicontent
    assert_equal("<p>revision 1</p>", wc('revision 1'))

    assert_equal("<ul>\n\t<li>list item</li>\n\t</ul>", wc('* list item'))

    assert_equal("<p><a href=\"free.fr\" title=\"title\">link</a></p>", 
                 wc('"link(title)":free.fr'))
    
    assert_equal("<p><code>CodeBlock</code></p>", wc('@CodeBlock@'))

  end
  
  def test_content_with_existing_masks
    assert_equal("<p>blah chunk123456wikichunkwordchunk blah blah</p>", 
                 wc('blah chunk123456wikichunkwordchunk blah blah'))
  end

  def test_include
    assert_equal("<p>revision 1 <a href=\"http://autolink.fr\">autolink.fr</a> <code>IncludedPage</code> content text HeyWord [[blah]]</p>", 
                 wc('revision 1 [[!include IncludedPage]]'))
  end

  def test_wikiword_in_wikicontent
    w = wc('Blah hey WikiWord \TuTu?')
    assert_equal("<p>Blah hey <span class=\"newWikiWord\">Wiki Word" + 
                   "<a href=\"../show/WikiWord\">?</a></span> TuTu?</p>", w)
    c = w.find_chunks(WikiChunk::Word)
    assert_equal("WikiWord", c[0].page_name)
    # escaped chunks should not be returned by find_chunks
    assert_equal(1, c.size)


    w = wc("Blah hey \\NoWikiWord ?")
    assert_equal("<p>Blah hey NoWikiWord ?</p>", w)
    c = w.find_chunks(WikiChunk::Word)
    assert_equal(0, c.size)

    assert_equal("<p>that <span class=\"newWikiWord\">Smart Engine GUI<a href=\"../show/SmartEngineGUI\">?</a></span></p>", wc('that SmartEngineGUI'))
  end

  def test_nowiki_in_wikicontent
    w = wc("Blah hey <nowiki>WikiWord ?</nowiki>")
    assert_equal("<p>Blah hey WikiWord ?</p>", w)
    
    assert_equal([], w.find_chunks(WikiChunk::Word))
    
    w = wc("Blah hey <nowiki>* nowiki</nowiki>")
    assert_equal("<p>Blah hey * nowiki</p>", w)

    assert_equal([], w.find_chunks(WikiChunk::Word))

    w = wc('Do not mark up <nowiki>this text</nowiki>, nor <nowiki>this one</nowiki>.')
    assert_equal("<p>Do not mark up this text, nor this one.</p>", w)

    w = wc('Do not mark up <nowiki>http://www.thislink.com</nowiki>.')
    assert_equal("<p>Do not mark up http://www.thislink.com.</p>", w)

    w = wc('Do not mark up <nowiki>[[this text]]</nowiki> ' +
	    'or <nowiki>http://www.thislink.com</nowiki>.')

    assert_equal("<p>Do not mark up [[this text]] or http://www.thislink.com.</p>", w)
  end

  def test_pipeline_wikicontent
    w = wc(<<HERE.gsub(/\n/,' ')
This sentence contains a WikiWord, a URI to
autolink www.example.com and
an [[AliasedLink|this cool link]].
It also has <pre>ProtectedText tototutu</pre>.
HERE
           )
    y = "<p>This sentence contains a <span class=\"newWikiWord\">Wiki Word<a href=\"../show/WikiWord\">?</a></span>, a <span class=\"caps\">URI</span> to autolink <a href=\"http://www.example.com\">www.example.com</a> and an <span class=\"newWikiWord\">this cool link<a href=\"../show/AliasedLink\">?</a></span>. It also has <pre>ProtectedText tototutu</pre>.</p>"
    assert_equal(y,w)

  end
end
