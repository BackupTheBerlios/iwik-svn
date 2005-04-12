require 'singleton'
require 'msglist'

class I18nService
  include Singleton
  attr_accessor :lang
  attr_accessor :table
  MSG_PATTERN = /_\('(.+?)'\)/m
  TRANS_DIR = File.dirname(__FILE__) + '/../translations'
  FILE_PATTERN = "??.rb"

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
    save_table(lang)
  end
  
  def filename(lang)
    "#{lang}.rb"
  end
  
  def read_po(fn)
    ret = {}
    in_translation_dir do
      File.read(fn).split(/\n{2,}/m).each{|s|
        s =~ /msgid\s+(.+)msgstr\s+(.+)/m
	ret[$1.strip] = $2.strip
      }
    end
    ret
  end
  
  def try_load
    loaded = true	
    if @lang and @lang.kind_of?(String) then
      fn = TRANS_DIR + "/" + filename(@lang)
      begin
        # @table = read_po(fn)
        Kernel::load(fn)
      rescue LoadError
        loaded = false
      end
    else
      loaded = false
    end
    loaded
  end
    
  def save_table(lang)
    in_translation_dir do
      FileUtils.cp(filename(lang), "#{filename(lang)}.bak") if test(?f, filename(lang))
      File.open(filename(lang), File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << @table.format_for_translation   
      }
    end
  end
end
  
