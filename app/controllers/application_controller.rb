class ApplicationController < ActionController::Base
  protect_from_forgery

  # Checks if User Session exists, if not, then this action raises a
  # 403 access denied message
  def require_login
    unless logged_in?
      response = {}
      response[:code] = 403
      response[:msg] = 'access denied'
      respond_to do |format|
        format.json { render json: response }
      end
    end
  end

  # The logged_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  # Note that this is not common in Ruby and is discouraged unless you
  # really mean to convert something into true or false.
  #
  # @return [Boolean]
  def logged_in?
    !!current_user
  end

  # Returns the current user associated to token:user-agent pair
  # available in header of current request, if this relation does
  # not exists nil object will be returned
  #
  # @return [User]
  def current_user
    token = request.authorization
    user_agent = request.user_agent
    SessionManager.current_user token, user_agent
  end
end
