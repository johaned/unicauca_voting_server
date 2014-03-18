class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :caption,               type: String
  field :affirmative_responses, type: Integer, default: 0
  field :negative_responses,    type: Integer, default: 0

  # Returns a current question according to current_question_method setting
  # contained into config/voting_service.yml
  #
  # @return [Question], by default it returns the lastest question
  def self.current_question
    voting_service_conf = YAML.load_file(Rails.root.join('config', 'voting_service.yml'))
    current_question_method = voting_service_conf['settings']['current_question_method']
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

  # This method increases either affirmative or negative response
  # according to user decision
  #
  # @param vote [String]
  #
  # @return [Integer], current number of votes in associated field
  def vote(vote)
    case vote
      when 'affirmative'
        self.inc :affirmative_responses, 1
      when 'negative'
        self.inc :negative_responses, 1
    end
  end

  # Returns a hash with lazy information regarding to voting results
  #
  # @return [Hash]
  def results
    results = {}
    results[:total_reponses] = affirmative_responses + negative_responses
    results[:affirmative_responses_percentage] = (affirmative_responses / (results[:total_reponses]*1.0) )
    results[:negative_responses_percentage] = (negative_responses / (results[:total_reponses]*1.0) )
    results[:affirmative_responses_percentage_caption] = "#{results[:affirmative_responses_percentage].round(2)* 100.0}%"
    results[:negative_responses_percentage_caption] = "#{results[:negative_responses_percentage].round(2)* 100.0}%"
    results
  end
end
