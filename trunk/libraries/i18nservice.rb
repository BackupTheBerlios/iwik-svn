require 'singleton'

class I18nService
  include Singleton
  attr_accessor :lang
  MSG_PATTERN = /_\('(.+?)'\)/m
  TABLE = Hash.new
end
  
