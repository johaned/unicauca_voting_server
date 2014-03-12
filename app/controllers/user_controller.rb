class UserController < ApplicationController

  before_filter :require_login

  def name
    current_user.name
  end

end
