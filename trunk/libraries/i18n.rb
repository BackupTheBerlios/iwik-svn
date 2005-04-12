#!/usr/bin/env ruby

require 'i18nservice'

i18n = I18nService.instance

def _(string)
  I18nService.instance.table.fetch(string, string) or string
end

unless i18n.try_load
  i18n.table = {}
  def _(string)
    string
  end
end