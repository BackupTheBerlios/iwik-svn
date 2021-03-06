#!/bin/env ruby 

require File.dirname(__FILE__) + '/../test_helper'
require 'file_controller'
require 'fileutils'

# Raise errors beyond the default web-based presentation
class FileController; def rescue_action(e) logger.error(e); raise e end; end

class FileControllerTest < Test::Unit::TestCase

  FILE_AREA = RAILS_ROOT + '/storage/test/wiki1'
  FileUtils.mkdir_p(FILE_AREA) unless File.directory?(FILE_AREA)
  FileUtils.rm(Dir["#{FILE_AREA}/*"])

  def setup
    setup_test_wiki
    setup_controller_test
  end

  def tear_down
    tear_down_wiki
  end

  def test_file
    process 'file', 'web' => 'wiki1', 'id' => 'foo.tgz'
    
    assert_success
    assert_rendered_file 'file/file'
  end

  def test_file_download_text_file
    File.open("#{FILE_AREA}/foo.txt", 'wb') { |f| f.write "aaa\nbbb\n" }
  
    r = process 'file', 'web' => 'wiki1', 'id' => 'foo.txt'
    
    assert_success
    assert_equal "aaa\nbbb\n", r.binary_content
    assert_equal 'text/plain', r.headers['Content-Type']
  end

  def test_file_download_pdf_file
    File.open("#{FILE_AREA}/foo.pdf", 'wb') { |f| f.write "aaa\nbbb\n" }
  
    r = process 'file', 'web' => 'wiki1', 'id' => 'foo.pdf'
    
    assert_success
    assert_equal "aaa\nbbb\n", r.binary_content
    assert_equal 'application/pdf', r.headers['Content-Type']
  end

  def test_pic_download_gif
    FileUtils.cp("#{RAILS_ROOT}/test/fixtures/rails.gif", FILE_AREA)
    
    r = process 'pic', 'web' => 'wiki1', 'id' => 'rails.gif'
    
    assert_success
    assert_equal File.size("#{FILE_AREA}/rails.gif"), r.binary_content.size
  end
  
  def test_pic_unknown_pic
    r = process 'pic', 'web' => 'wiki1', 'id' => 'non-existant.gif'
    
    assert_success
    assert_rendered_file 'file/file'
  end

  def test_pic_upload_end_to_end
    # edit and re-render home page so that it has an "unknown file" link to 'rails-e2e.gif'
    @wiki.revise_page('wiki1', 'HomePage', '[[rails-e2e.gif:pic]]', Time.now, 'AnonymousBrave')
    assert_equal "<p><span class=\"newWikiWord\">rails-e2e.gif<a href=\"../pic/rails-e2e.gif\">" +
        "?</a></span></p>", 
        @home.display_content
  
    # rails-e2e.gif is unknown to the system, so pic action goes to the file [upload] form
    r = process 'pic', 'web' => 'wiki1', 'id' => 'rails-e2e.gif'
    assert_success
    assert_rendered_file 'file/file'

    # User uploads the picture
    picture = File.read("#{RAILS_ROOT}/test/fixtures/rails.gif")
    r = process 'pic', 'web' => 'wiki1', 'id' => 'rails-e2e.gif', 'file' => StringIO.new(picture)
    assert_redirect_url '/'
    assert @wiki.file_yard(@web).has_file?('rails-e2e.gif')
    assert_equal(picture, File.read("#{RAILS_ROOT}/storage/test/wiki1/rails-e2e.gif"))
    
    # this should refresh the page display content (cached)
    assert_equal "<p><img alt=\"rails-e2e.gif\" src=\"../pic/rails-e2e.gif\" /></p>", 
        @home.display_content
  end

  def test_pic_upload_end_to_end
    # edit and re-render home page so that it has an "unknown file" link to 'rails-e2e.gif'
    @wiki.revise_page('wiki1', 'HomePage', '[[instiki-e2e.txt:file]]', Time.now, 'AnonymousBrave')
    assert_equal "<p><span class=\"newWikiWord\">instiki-e2e.txt" +
        "<a href=\"../file/instiki-e2e.txt\">?</a></span></p>", 
        @home.display_content
        
    # rails-e2e.gif is unknown to the system, so pic action goes to the file [upload] form
    r = process 'file', 'web' => 'wiki1', 'id' => 'instiki-e2e.txt'
    assert_success
    assert_rendered_file 'file/file'

    # User uploads the picture
    file = "abcdefgh\n123"
    r = process 'file', 'web' => 'wiki1', 'id' => 'instiki-e2e.txt', 'file' => StringIO.new(file)
    assert_redirect_url '/'
    assert @wiki.file_yard(@web).has_file?('instiki-e2e.txt')
    assert_equal(file, File.read("#{RAILS_ROOT}/storage/test/wiki1/instiki-e2e.txt"))
    
    # this should refresh the page display content (cached)
    assert_equal "<p><a class=\"existingWikiWord\" href=\"../file/instiki-e2e.txt\">" +
        "instiki-e2e.txt</a></p>", 
        @home.display_content
  end

  def test_uploads_blocking
    @web.allow_uploads = true
    r = process 'file', 'web' => 'wiki1', 'id' => 'filename'
    assert_success

    @web.allow_uploads = false
    r = process 'file', 'web' => 'wiki1', 'id' => 'filename'
    assert_equal '403 Forbidden', r.headers['Status']
  end

end
