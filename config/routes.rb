Rails.application.routes.draw do
  root to: "api/v1/companies#index"

  namespace :api do
    namespace :v1 do
      resources :companies, only: %i[index show create] do
        resources :collaborators, shallow: true
      end
    end
  end
end
