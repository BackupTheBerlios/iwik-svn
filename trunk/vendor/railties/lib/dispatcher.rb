#--
# Copyright (c) 2004 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'breakpoint'

class Dispatcher
  class << self
    def dispatch(cgi = CGI.new, session_options = ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS)
      begin
        request, response = ActionController::CgiRequest.new(cgi, session_options), ActionController::CgiResponse.new(cgi)
        prepare_application
        ActionController::Routing::Routes.recognize!(request).process(request, response).out
      rescue Object => exception
        ActionController::Base.process_with_exception(request, response, exception).out
      ensure
        reset_application
      end
    end
    
    private
      def prepare_application
        ActionController::Routing::Routes.reload if Dependencies.load?
        Breakpoint.activate_drb("druby://localhost:#{BREAKPOINT_SERVER_PORT}", nil, !defined?(FastCGI)) if defined?(BREAKPOINT_SERVER_PORT) rescue nil
        Controllers.const_load!(:ApplicationController, "application") unless Controllers.const_defined?(:ApplicationController)
      end
    
      def reset_application
        if Dependencies.load?
          Controllers.clear!
          Dependencies.clear
          Dependencies.remove_subclasses_for(ActiveRecord::Base, ActiveRecord::Observer, ActionController::Base)
        end

        Breakpoint.deactivate_drb if defined?(BREAKPOINT_SERVER_PORT)
      end
  end
end
