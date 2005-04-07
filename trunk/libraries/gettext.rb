require 'i18nservice'

class Mesg < String
  def format_for_translation
    "'#{self}' => ''"
  end
end

class MsgList < Array
  def format_for_translation
    head = <<HEAD
#!/usr/bin/env ruby

require 'i18nservice'

I18nService::TABLE = {
HEAD
    
    content = collect{|m| m.format_for_translation}.join(",\n")
    
    head + content + "\n}"
  end

end

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
    list.collect!{|m| Mesg.new(m)}
    MsgList.new(list.sort)
  end
  # write a formated file with the english strings to translate
  def write_template
    File.open("translations/en.template.rb", 
              File::CREAT|File::WRONLY|File::TRUNC){|f|
      f << msg_list.format_for_translation   
    }
  end
end

