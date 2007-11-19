module AuthenticatedSystem
  protected
    
    AUTHENTICATED_USER_TYPES = [:bunny]
    
    # Convenience methods for each kind of user
    AUTHENTICATED_USER_TYPES.each do |user_type|
      eval <<-END
        def #{user_type}_logged_in?
          user_logged_in?(:#{user_type})
        end
        
        def current_#{user_type}
          current_user(:#{user_type})
        end
        
        def current_#{user_type}=(new_user)
          set_current_user(:#{user_type} => new_user)
        end
        
        def #{user_type}_authorized?
          user_authorized?(:#{user_type})
        end
        
        def #{user_type}_login_required
          user_login_required(:#{user_type})
        end
        
        def #{user_type}_login_from_cookie
          user_login_from_cookie(:#{user_type})
        end
      END
    end
    
    # Inclusion hooks to make #current_{user_type} and #{user_type}_logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      AUTHENTICATED_USER_TYPES.each do |user_type|
        base.send(:helper_method, "current_#{user_type}".to_sym, "#{user_type}_logged_in?".to_sym)
      end
    end
    
    # For a given user type (e.g. :player), returns true or false if that type
    # of user is logged in.
    # If they are logged in, it also populates an instance variable (e.g. @current_player)
    # with the user object.
    def user_logged_in?(user_type)
      current_user = self.instance_variable_get("@current_#{user_type}".to_sym)
      klass = eval(user_type.to_s.camelize)
      current_user ||= session[user_type] ? klass.find_by_id(session[user_type]) : :false
      self.instance_variable_set("@current_#{user_type}".to_sym, current_user)
      current_user.is_a?(klass)
    end
    
    
    # Returns the current user object from the session for the given user type
    def current_user(user_type)
      instance_variable_get("@current_#{user_type}") if user_logged_in?(user_type)
    end
    
    # Stores the give user object in the session as the 'current' user:
    # set_current_user(:player => new_player)
    def set_current_user(options)
      unless options.is_a?(Hash) && options.length == 1
        raise ArgumentError, "options must be a Hash of the form {:player => new_player}"
      end
      
      user_type = options.keys.first
      new_user = options.values.first
      
      session[user_type] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
      instance_variable_set("@current_#{user_type}".to_sym, new_user)
    end
    
    # Check if user is authorized.
    # Override the individual user_type versions for more complex authorization
    def user_authorized?(user_type)
      true
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :user_login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :user_login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :user_login_required
    #
    # replacing 'user' with the appropriate user type.
    def user_login_required(user_type)
      username, passwd = get_auth_data
      klass = eval(user_type.to_s.camelize)
      new_user = klass.authenticate(username, passwd) || :false if username && passwd
      set_current_user(user_type => new_user) unless current_user(user_type)
      user_logged_in?(user_type) && user_authorized?(user_type) ? true : user_access_denied(user_type)
    end
    
    
    # Redirect as appropriate when an access request fails.
    # By default, we redirect to the appropriate login screen.
    def user_access_denied(user_type)
      respond_to do |accepts|
        accepts.html do
          store_location
          flash[:notice] = "You must log in first"
          redirect_to(:controller => "/#{user_type.to_s}_sessions", :action => :new)
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Couldn't authenticate you", :status => '401 Unauthorized'
        end
      end
      false
    end
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    

    
    # When called from a before_filter (using the appropriate user_type version),
    # will check for the appropriate auth_token cookie, and login the appropriate user
    # if it's okay.
    def user_login_from_cookie(user_type)
      auth_token_name = "#{user_type}_auth_token".to_sym
      return unless cookies[auth_token_name] && !user_logged_in?(user_type)
      klass = eval(user_type.to_s.camelize)
      user = klass.find_by_remember_token(cookies[auth_token_name])
      if user && user.remember_token?
        user.remember_me
        set_current_user(user_type => user)
        cookies[auth_token_name] = {:value => current_user(user_type).remember_token, :expires => current_user(user_type).remember_token_expires_at}
        flash[:notice] = "Logged in successfully"
      end
    end
    

  private
    # gets BASIC auth info
    def get_auth_data
      user, pass = nil, nil
      # extract authorisation credentials 
      if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
        # try to get it where mod_rewrite might have put it 
        authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
      elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
        # this is the regular location 
        authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
      end 
       
      # at the moment we only support basic authentication 
      if authdata && authdata[0] == 'Basic' 
        user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
      end 
      return [user, pass] 
    end
end
