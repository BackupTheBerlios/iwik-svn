#!/usr/bin/env ruby

require 'i18nservice'

i18nserv = I18nService.instance

def _(string)
  I18nService::TABLE.fetch(string, string) 
end

case i18nserv.lang
when "fr"
  require 'translations/fr'
else
  def _(string)
    string
  end
end