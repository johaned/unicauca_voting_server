class QuestionsController < ApplicationController
  before_filter :require_login

  def current_question
  end

  def vote
  end

  def results
  end

end
