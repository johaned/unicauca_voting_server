class SessionController < ApplicationController
  def sign_in
    username = params[:username]
    password = params[:password]
    user_agent = request.user_agent

    response = SessionManager.authenticate username, password, user_agent

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
