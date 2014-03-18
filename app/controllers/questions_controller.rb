class QuestionsController < ApplicationController
  before_filter :require_login

  def current_question
    current_question = Question.current_question
    respond_to do |format|
      format.json { render json: (current_question.caption || 'No question...') }
    end
  end

  def vote
    current_question = Question.current_question
    current_question.vote(params[:vote])
    respond_to do |format|
      format.json { render json: 'Voted' }
    end
  end

  def results
    current_question = Question.current_question
    respond_to do |format|
      format.json { render json: current_question.results }
    end
  end

end
