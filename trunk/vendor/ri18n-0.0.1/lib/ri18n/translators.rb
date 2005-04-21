#!/usr/bin/env ruby

i18n = I18nService.instance

def _(string)
  fetch = I18nService.instance.table.fetch(string, string) 
  fetch.empty? ? string : fetch
end

# string with interpolation part(s)
def _i(string, b = self.getBinding)
  ret = I18nService.instance.table.fetch(string, string) || string
  ret.interpolate(b)
end

# plurals
def n_(msgid, msgid_plural, n)
  ret = I18nService.instance.table[msgid]
	unless ret.empty? 
		sprintf(ret.plurals[plural_form(n)], n)
  else
		sprintf(n == 1 ? msgid : msgid_plural, n)
	end
end

unless i18n.try_load
  i18n.table = {}
  def _(string)
    string
  end

  def _i(string, b = self.getBinding)
    string.interpolate(b)
  end

	def n_(msgid, msgid_plural, n)
		sprintf(n == 1 ? msgid : msgid_plural, n)
	end
end