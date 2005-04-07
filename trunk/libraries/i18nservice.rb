require 'singleton'

class I18nService
  include Singleton
  attr_accessor :lang
  MSG_PATTERN = /_\('(.+?)'\)/m
  def lang=(l)
    unless ( @lang == l ) 
      @lang = l 
      load 'i18n.rb' 
    end
  end
end
  
