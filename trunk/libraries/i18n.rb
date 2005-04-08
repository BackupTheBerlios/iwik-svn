#!/usr/bin/env ruby

require 'i18nservice'


def _(string)
  I18nService.instance.table.fetch(string, string) or string
end

i18n = I18nService.instance
default_lang=false

if i18n.lang and i18n.lang.kind_of?(String) then
  fn = I18nService::TRANS_DIR + "/" + i18n.filename(i18n.lang)
  begin
    Kernel::load(fn)
  rescue LoadError
    default_lang=true
  end
else
  default_lang=true
end

if default_lang
  i18n.table = {}
  def _(string)
    string
  end
end