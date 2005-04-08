require 'i18nservice'
require 'msglist'

I18N = I18nService.instance


class I18nFileList < Rake::FileList
  def msg_list 
    list = []
    each{|fn|
      next unless test(?f, fn)
      File.open(fn) do |f|
        list += f.read.scan(I18nService::MSG_PATTERN).flatten
      end
    }
    list.uniq!
    ret = Hash.new
    list.each{|m| ret[m] = nil}
    ret
  end
  # write a formated file with the english strings to translate
  def write_template
    File.open("translations/en.template.rb", 
              File::CREAT|File::WRONLY|File::TRUNC){|f|
      f << msg_list.format_for_translation   
    }
  end
  def update
    I18N.update_languages(msg_list)
  end
end

