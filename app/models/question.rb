class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :caption,               type: String
  field :affirmative_responses, type: Integer
  field :negative_responses,    type: Integer

  # Returns a current question according to current_question_method setting
  # contained into config/voting_service.yml
  #
  # @return [Question], by default it returns the lastest question
  def self.current_question
    voting_service_conf = YAML.load_file(Rails.root.join('config', 'voting_service.yml'))
    current_question_method = voting_service_conf['setings']['current_question_method']
    current_question_method = current_question_method || 'last'
    case current_question_method
      when 'first'
        Question.first
      when 'last'
        Question.last
      when /^[[:xdigit:]]{24}$/
        id = current_question_method
        Question.find id
      else
        Question.last
    end
  end
end
