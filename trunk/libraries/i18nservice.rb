require 'singleton'

class I18nService
  include Singleton
  MSG_PATTERN = /i18n\('(.+?)'\)/m
end
  
