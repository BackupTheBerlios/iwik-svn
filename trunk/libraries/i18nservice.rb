require 'singleton'

class I18nService
  include Singleton
  attr_accessor :lang
  MSG_PATTERN = /i18n\('(.+?)'\)/m
  TABLE = Hash.new
end
  
