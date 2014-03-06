class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    token = request.authorization
    user_agent = request.user_agent
    SessionManager.current_user token, user_agent
  end
end
