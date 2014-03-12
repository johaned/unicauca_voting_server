VotingServer::Application.routes.draw do
  post '/sign_in', to: 'session#sign_in'
  post '/user/name', to: 'user#name'
end
