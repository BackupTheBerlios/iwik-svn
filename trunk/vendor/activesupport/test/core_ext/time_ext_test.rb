require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/active_support/core_ext/numeric'
require File.dirname(__FILE__) + '/../../lib/active_support/core_ext/time'

class TimeExtCalculationsTest < Test::Unit::TestCase
  def test_seconds_since_midnight
    assert_equal 1,Time.local(2005,1,1,0,0,1).seconds_since_midnight
    assert_equal 60,Time.local(2005,1,1,0,1,0).seconds_since_midnight
    assert_equal 3660,Time.local(2005,1,1,1,1,0).seconds_since_midnight
    assert_equal 86399,Time.local(2005,1,1,23,59,59).seconds_since_midnight
    assert_equal 60.00001,Time.local(2005,1,1,0,1,0,10).seconds_since_midnight
  end

  def test_begining_of_week
    assert_equal Time.local(2005,1,31), Time.local(2005,2,4,10,10,10).beginning_of_week
  end
  
  def test_beginning_of_day
    assert_equal Time.local(2005,2,4,0,0,0), Time.local(2005,2,4,10,10,10).beginning_of_day
  end
  
  def test_beginning_of_month
    assert_equal Time.local(2005,2,1,0,0,0), Time.local(2005,2,22,10,10,10).beginning_of_month
  end
  
  def test_beginning_of_year
    assert_equal Time.local(2005,1,1,0,0,0), Time.local(2005,2,22,10,10,10).beginning_of_year
  end
    
  def test_months_ago
    assert_equal Time.local(2005,5,5,10),  Time.local(2005,6,5,10,0,0).months_ago(1)
    assert_equal Time.local(2004,11,5,10), Time.local(2005,6,5,10,0,0).months_ago(7)
    assert_equal Time.local(2004,12,5,10), Time.local(2005,6,5,10,0,0).months_ago(6)
    assert_equal Time.local(2004,6,5,10),  Time.local(2005,6,5,10,0,0).months_ago(12)
    assert_equal Time.local(2003,6,5,10),  Time.local(2005,6,5,10,0,0).months_ago(24)
  end

  def test_months_since
    assert_equal Time.local(2005,7,5,10),  Time.local(2005,6,5,10,0,0).months_since(1)
    assert_equal Time.local(2005,12,5,10), Time.local(2005,6,5,10,0,0).months_since(6)
    assert_equal Time.local(2006,1,5,10),  Time.local(2005,6,5,10,0,0).months_since(7)
    assert_equal Time.local(2006,6,5,10),  Time.local(2005,6,5,10,0,0).months_since(12)
    assert_equal Time.local(2007,6,5,10),  Time.local(2005,6,5,10,0,0).months_since(24)
  end
  
  def test_years_ago
    assert_equal Time.local(2004,6,5,10),  Time.local(2005,6,5,10,0,0).years_ago(1)
    assert_equal Time.local(1998,6,5,10), Time.local(2005,6,5,10,0,0).years_ago(7)
  end
  
  def test_years_since
    assert_equal Time.local(2006,6,5,10),  Time.local(2005,6,5,10,0,0).years_since(1)
    assert_equal Time.local(2012,6,5,10),  Time.local(2005,6,5,10,0,0).years_since(7)
    # Failure because of size limitations of numeric?
    # assert_equal Time.local(2182,6,5,10),  Time.local(2005,6,5,10,0,0).years_since(177) 
  end
  

  def test_ago
    assert_equal Time.local(2005,2,22,10,10,9),  Time.local(2005,2,22,10,10,10).ago(1)
    assert_equal Time.local(2005,2,22,9,10,10),  Time.local(2005,2,22,10,10,10).ago(3600)
    assert_equal Time.local(2005,2,20,10,10,10), Time.local(2005,2,22,10,10,10).ago(86400*2)
    assert_equal Time.local(2005,2,20,9,9,45),   Time.local(2005,2,22,10,10,10).ago(86400*2 + 3600 + 25)
  end 
  
  def test_since
    assert_equal Time.local(2005,2,22,10,10,11), Time.local(2005,2,22,10,10,10).since(1)
    assert_equal Time.local(2005,2,22,11,10,10), Time.local(2005,2,22,10,10,10).since(3600)
    assert_equal Time.local(2005,2,24,10,10,10), Time.local(2005,2,22,10,10,10).since(86400*2)
    assert_equal Time.local(2005,2,24,11,10,35), Time.local(2005,2,22,10,10,10).since(86400*2 + 3600 + 25)
  end

  def test_yesterday
    assert_equal Time.local(2005,2,21,10,10,10), Time.local(2005,2,22,10,10,10).yesterday
    assert_equal Time.local(2005,2,28,10,10,10), Time.local(2005,3,2,10,10,10).yesterday.yesterday
  end
  
  def test_tomorrow
    assert_equal Time.local(2005,2,23,10,10,10), Time.local(2005,2,22,10,10,10).tomorrow
    assert_equal Time.local(2005,3,2,10,10,10),  Time.local(2005,2,28,10,10,10).tomorrow.tomorrow
  end
  
  def test_change
    assert_equal Time.local(2006,2,22,15,15,10), Time.local(2005,2,22,15,15,10).change(:year => 2006)
    assert_equal Time.local(2005,6,22,15,15,10), Time.local(2005,2,22,15,15,10).change(:month => 6)
    assert_equal Time.local(2012,9,22,15,15,10), Time.local(2005,2,22,15,15,10).change(:year => 2012, :month => 9)
    assert_equal Time.local(2005,2,22,16),       Time.local(2005,2,22,15,15,10).change(:hour => 16)
    assert_equal Time.local(2005,2,22,16,45),    Time.local(2005,2,22,15,15,10).change(:hour => 16, :min => 45)
    assert_equal Time.local(2005,2,22,15,45),    Time.local(2005,2,22,15,15,10).change(:min => 45)
  end
  
  def test_utc_change
    assert_equal Time.utc(2006,2,22,15,15,10), Time.utc(2005,2,22,15,15,10).change(:year => 2006)
    assert_equal Time.utc(2005,6,22,15,15,10), Time.utc(2005,2,22,15,15,10).change(:month => 6)
    assert_equal Time.utc(2012,9,22,15,15,10), Time.utc(2005,2,22,15,15,10).change(:year => 2012, :month => 9)
    assert_equal Time.utc(2005,2,22,16),       Time.utc(2005,2,22,15,15,10).change(:hour => 16)
    assert_equal Time.utc(2005,2,22,16,45),    Time.utc(2005,2,22,15,15,10).change(:hour => 16, :min => 45)
    assert_equal Time.utc(2005,2,22,15,45),    Time.utc(2005,2,22,15,15,10).change(:min => 45)
  end
  
  def test_next_week
    assert_equal Time.local(2005,2,28), Time.local(2005,2,22,15,15,10).next_week
    assert_equal Time.local(2005,2,29), Time.local(2005,2,22,15,15,10).next_week(:tuesday)
    assert_equal Time.local(2005,3,4), Time.local(2005,2,22,15,15,10).next_week(:friday)
  end

  def test_to_s
    assert_equal "2005-02-21 17:44:30",     Time.local(2005, 2, 21, 17, 44, 30).to_s(:db)
    assert_equal "21 Feb 17:44",            Time.local(2005, 2, 21, 17, 44, 30).to_s(:short)
    assert_equal "February 21, 2005 17:44", Time.local(2005, 2, 21, 17, 44, 30).to_s(:long)
  end
  
  def test_to_date
    assert_equal Date.new(2005, 2, 21), Time.local(2005, 2, 21, 17, 44, 30).to_date
  end
  
  def test_to_time
    assert_equal Time.local(2005, 2, 21, 17, 44, 30), Time.local(2005, 2, 21, 17, 44, 30).to_time
  end
end