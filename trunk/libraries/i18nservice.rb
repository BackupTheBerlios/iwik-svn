require 'singleton'
require 'msglist'

class I18nService
  include Singleton
  attr_accessor :lang
  attr_accessor :table
  
  MSG_PATTERN = /_\('(.+?)'\)/m
  TRANS_DIR = File.dirname(__FILE__) + '/../translations'
  FILE_PATTERN = "??.po"

  def lang=(l)
    unless ( @lang == l ) 
      @lang = l 
      load 'i18n.rb' 
    end
  end

  def in_translation_dir
    wd = Dir.getwd
    ret = nil
    begin
      Dir.chdir(TRANS_DIR)
      ret = yield
    ensure
      Dir.chdir(wd)
    end
    ret
  end
  # access the translation files
  def each_file
    in_translation_dir do
      Dir[FILE_PATTERN].each{|fn| yield fn}
    end
  end
  
  def available_languages
    ret = in_translation_dir do
      Dir[FILE_PATTERN]
    end
    ret.collect{|fn| fn[0,2]}.sort
  end  
  
  def update_languages(new_msgs)
    available_languages.each{|la| self.update(la, new_msgs)    }
  end
  
  def update(lang, new_msgs)
    self.lang = lang
    @table = new_msgs.update(@table)
    write_po(lang)
  end
  
  def filename(lang)
    "#{lang}.po"
  end
  
  def read_po(fn)
    ret = {}
    in_translation_dir do
      File.read(fn).split(/(?:\n\n)|(?:\n \n)/m).each{|s|
        s =~ /msgid\s+(.+)msgstr\s+(.*)/m
        str = $2.strip
        id = $1.strip[1..-2]
        ret[id] = ((str == '""') ? nil : str[1..-2])
      }
    end
    ret
  end
  
  def try_load
    loaded = true	
    if @lang and @lang.kind_of?(String) then
      fn = TRANS_DIR + "/" + filename(@lang)
      begin
        @table = read_po(fn)
      rescue Errno::ENOENT
        loaded = false
      end
    else
      loaded = false
    end
    loaded
  end
    
  def write_po(lang)
    fname = filename(lang)
    in_translation_dir do
      FileUtils.cp(fname, "#{fname}.bak") if test(?f, fname)
      File.open(fname, File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << @table.po_format   
      }
    end
  end

end



