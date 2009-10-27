module AuthenticatedTestHelper
  # Sets the current 'user_type' in the session from the appropriate fixtures.
  # e.g. login_as(:advertiser => :alice)
  def login_as(options)
    raise ArgumentError, "User type not specified" unless options.respond_to?(:keys)
    user_type = options.keys.first
    plural_user_type = (user_type.to_s.pluralize).to_sym
    user = options.values.first
    @request.session[user_type] = user ? self.send(plural_user_type, user).id : nil
  end
  
  def content_type(type)
    @request.env['Content-Type'] = type
  end

  def accept(accept)
    @request.env["HTTP_ACCEPT"] = accept
  end

  def authorize_as(user)
    if user
      @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64.encode64("#{users(user).login}:test")}"
      accept       'application/xml'
      content_type 'application/xml'
    else
      @request.env["HTTP_AUTHORIZATION"] = nil
      accept       nil
      content_type nil
    end
  end

  # Assert the block redirects to the login
  # 
  #   assert_requires_login(:bob) { |c| c.get :edit, :id => 1 }
  #
  def assert_requires_login(login = nil)
    yield HttpLoginProxy.new(self, login)
  end

  def assert_http_authentication_required(login = nil)
    yield XmlLoginProxy.new(self, login)
  end

  def reset!(*instance_vars)
    instance_vars = [:controller, :request, :response] unless instance_vars.any?
    instance_vars.collect! { |v| "@#{v}".to_sym }
    instance_vars.each do |var|
      instance_variable_set(var, instance_variable_get(var).class.new)
    end
  end
end

class BaseLoginProxy
  attr_reader :controller
  attr_reader :options
  def initialize(controller, login)
    @controller = controller
    @login      = login
  end

  private
    def authenticated
      raise NotImplementedError
    end
    
    def check
      raise NotImplementedError
    end
    
    def method_missing(method, *args)
      @controller.reset!
      authenticate
      @controller.send(method, *args)
      check
    end
end

class HttpLoginProxy < BaseLoginProxy
  protected
    def authenticate
      @controller.login_as @login if @login
    end
    
    def check
      @controller.assert_redirected_to :controller => 'account', :action => 'login'
    end
end

class XmlLoginProxy < BaseLoginProxy
  protected
    def authenticate
      @controller.accept 'application/xml'
      @controller.authorize_as @login if @login
    end
    
    def check
      @controller.assert_response 401
    end
end