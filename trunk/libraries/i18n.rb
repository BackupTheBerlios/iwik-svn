#!/usr/bin/env ruby

require 'i18nservice'

i18nserv = I18nService.instance

case i18nserv.lang
when "fr"
  require 'translations/fr'
  def i18n(string)
    I18nService::TABLE["fr"][string] or string
  end
else
  def i18n(string)
    string
  end
end