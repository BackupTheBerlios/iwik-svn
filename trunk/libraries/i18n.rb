#!/usr/bin/env ruby

require 'i18nservice'


def _(string)
  I18nService.instance.table.fetch(string, string) or string
end


  if I18nService.instance.lang and I18nService.instance.lang.kind_of?(String) then
    Kernel::load I18nService::TRANS_DIR + "/#{I18nService.instance.lang}.rb"
  else
    def _(string)
      string
    end
  end
