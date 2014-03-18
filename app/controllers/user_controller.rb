class UserController < ApplicationController

  before_filter :require_login

  def name
    respond_to do |format|
      format.json { render json: (current_user.name || '') }
    end
  end

end
