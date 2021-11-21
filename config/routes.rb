Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/currency_options", to: "exchange#currency_options"
  get "/convert_currency", to: "exchange#convert_currency"
end
