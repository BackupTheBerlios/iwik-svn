require 'singleton'

class I18nService
  include Singleton
  attr_accessor :lang
  MSG_PATTERN = /_\('(.+?)'\)/m
  def lang=(l)
    load 'i18n.rb' unless @lang == l
    @lang = l 
  end
end
  
