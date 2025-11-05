Rails.application.routes.draw do
  get "timesheets/index"
  devise_for :users
  root "timesheets#index"
  get "home/index"

  resources :work_items, only: [:new, :create, :edit, :update, :destroy, :show]

  resource :timesheet, only: [] do
    post :prefill   # /timesheet/prefill
  end

  get "up" => "rails/health#show", as: :rails_health_check


  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
