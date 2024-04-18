# config/routes.rb
Rails.application.routes.draw do
  root 'predictions#index'
  post '/predictions/create', to: 'predictions#create'
  post '/predictions/rate', to: 'predictions#rate'
  # get '/predictions/show', to: 'predictions#show'
end
