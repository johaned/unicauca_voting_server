VotingServer::Application.routes.draw do
  post '/sign_in', to: 'session#sign_in'
end
