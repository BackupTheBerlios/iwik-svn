#!/usr/bin/env ruby

require 'i18nservice'

i18n = I18nService.instance

def _(string)
  ret = I18nService.instance.table.fetch(string, string) || string
end

def _i(string, b = self.getBinding)
  ret = I18nService.instance.table.fetch(string, string) || string
  ret.interpolate(b)
end

unless i18n.try_load
  i18n.table = {}
  def _(string)
    string
  end
  
  def _i(string, b = self.getBinding)
    string.interpolate(b)
  end
 
end