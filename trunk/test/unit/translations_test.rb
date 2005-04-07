#!/usr/bin/env ruby 

require File.dirname(__FILE__) + '/../test_helper'

require 'i18nservice'

I18N = I18nService.instance

class TranslationTest < Test::Unit::TestCase
  # reset to default
  def setup
    I18N.lang = nil
  end

  def test_default_is_english
    assert_equal('Test String', _('Test String'))
  end
  
  def test_loading
    I18N.lang = "fr"
    assert_equal('Test de cuisson', _('Cooking test'))
    
    I18N.lang = "de"
    assert_equal('Kochtest', _('Cooking test'))
  end
  
  def test_utf8_chars
    I18N.lang = "fr"
    assert_equal('Chaîne de Test', _('Test String'))
  end
end