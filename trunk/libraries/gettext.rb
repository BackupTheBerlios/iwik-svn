require 'i18nservice'

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
  end
end

