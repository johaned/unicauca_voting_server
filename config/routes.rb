VotingServer::Application.routes.draw do
  post '/sign_in', to: 'session#sign_in'
  post '/user/name', to: 'user#name'
  post '/questions/current_question', to: 'questions#current_question'
  post '/questions/vote', to: 'questions#vote'
  post '/questions/results', to: 'questions#results'

end
