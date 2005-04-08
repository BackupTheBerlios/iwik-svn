#!/usr/bin/env ruby 

require File.dirname(__FILE__) + '/../test_helper'

require 'i18nservice'

I18N = I18nService.instance

class GettextTest < Test::Unit::TestCase
  def test_available
    wd = Dir.getwd
    assert_equal(%w{de fr xx}, I18N.available_languages)
    
    # check that workdir is not changed
    assert_equal(wd, Dir.getwd)
  end
end

class TranslationTest < Test::Unit::TestCase
  # reset to default
  def setup
    I18N.lang = nil
  end

  def test_default_is_english
    assert_equal('Test String', _('Test String'))
  end

  def test_load_and_save
    I18N.table = {'blue' => 'bleu', 'summer' => 'été', 'untranslated' => nil}
    I18N.save_table('xx')
    
    I18N.lang = nil
    assert_equal('blue', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('summer', _('summer'))
    
    I18N.lang = "xx"
    assert_equal('bleu', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('été', _('summer'))

    assert_equal({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => nil}, I18N.table)
    
  end
    
  def test_simple
    I18N.lang = "fr"
    assert_equal('Test de cuisson', _('Cooking test'))
    
    I18N.lang = "de"
    assert_equal('Kochtest', _('Cooking test'))
  end
  
  def test_utf8_chars
    I18N.lang = "fr"
    assert_equal('Chaîne de Test', _('Test String'))
    assert_equal('Été', _('Summer'))
    assert_equal('été', _('summer'))
   
    I18N.lang = "de"
    assert_equal('Straße', _('Road'))
  end
end