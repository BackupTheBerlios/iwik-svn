#!/usr/bin/env ruby

require 'i18nservice'

case ENV['IWIK_LANG']
when "fr"
  require 'translations/fr'
  def i18n(string)
    $i18n_table["fr"][string] or string
  end
else
  def i18n(string)
    string
  end
end