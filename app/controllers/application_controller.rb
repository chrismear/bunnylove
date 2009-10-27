# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  filter_parameter_logging :password, :message
  
  protect_from_forgery
  
  include AuthenticatedSystem
  
  private
  
  def rescue_action_in_public(exception)
    case exception
      when *self.class.exceptions_to_treat_as_404
        render_404
      when ActionController::InvalidAuthenticityToken
        render_500
      else
        render_500
        
        deliverer = self.class.exception_data
        data = case deliverer
          when nil then {}
          when Symbol then send(deliverer)
          when Proc then deliverer.call(self)
        end
        
        ExceptionNotifier.deliver_exception_notification(exception, self,
          request, data)
    end
  end
end
