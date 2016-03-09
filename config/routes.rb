Rails.application.routes.draw do
 
devise_for :users, controllers:  {
  registrations: 'users/registrations'
  }
  root :to => "whale#view_counter"
  match ":controller(/:action(/:id))", :via => [:post, :get]
  
end
