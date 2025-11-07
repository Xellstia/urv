Rails.application.routes.draw do
  get "timesheets/index"
  devise_for :users
  root "timesheets#index"
  get "home/index"

  resources :work_items, only: [:new, :create, :edit, :update, :destroy, :show]

  resource :timesheet, only: [] do
    post :prefill   # /timesheet/prefill
  end

  # Расписание (Weekly Presets)
  resources :presets, only: [:index] do
    resources :preset_items, only: [:new, :create, :edit, :update, :destroy]
  end

   # ШАБЛОНЫ (категории и карточки)
  resources :template_categories, except: [:show] do
    member { patch :toggle_collapse }
    resources :template_cards, except: [:show]
  end

  # Пикер шаблонов (окно, которое открывается в колонке дня)
  resource :templates_picker, only: [:show], controller: "templates_picker" do
    post :add
  end

  get "up" => "rails/health#show", as: :rails_health_check


  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
