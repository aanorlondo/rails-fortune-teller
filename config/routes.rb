Rails.application.routes.draw do
  root 'predictions#index'
  get '/fortuneteller', to: 'predictions#index'
  post '/fortuneteller/predictions/create', to: 'predictions#create'
  post '/fortuneteller/predictions/rate', to: 'predictions#rate'
  get '/fortuneteller/predictions/list', to: 'predictions#list'
  get '/fortuneteller/predictions/show', to: 'predictions#show'
end
