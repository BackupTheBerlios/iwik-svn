require File.dirname(__FILE__) + '/../abstract_unit'

class RedirectController < ActionController::Base
  def simple_redirect
    redirect_to :action => "hello_world"
  end
  
  def method_redirect
    redirect_to :dashbord_url, 1, "hello"
  end
  
  def rescue_errors(e) raise e end
  
  protected
    def dashbord_url(id, message)
      url_for :action => "dashboard", :params => { "id" => id, "message" => message }
    end
end

class RedirectTest < Test::Unit::TestCase
  def setup
    @controller = RedirectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_simple_redirect
    get :simple_redirect
    assert_redirect_url "http://test.host/redirect/hello_world"
  end

  def test_redirect_with_method_reference_and_parameters
    get :method_redirect
    assert_redirect_url "http://test.host/redirect/dashboard/1?message=hello"
  end
end