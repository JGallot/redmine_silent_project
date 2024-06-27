# frozen_string_literal: true

resources :silent_statuses, :path =>'silent_status'
resources :project_notifications do

get :project_notifications, action: :index, controller: :project_notifications

collection do
  post 'update'
end
end