#!/usr/bin/env ruby

require 'i18nservice'

i18nserv = I18nService.instance

def _(string)
  I18nService::TABLE.fetch(string, string) 
end


  if i18nserv.lang and i18nserv.lang.kind_of?(String) then
    load File.dirname(__FILE__) + "/../translations/#{i18nserv.lang}.rb"
  else
    def _(string)
      string
    end
  end
