Frontpack::Engine.routes.draw do
  get 'autocomplete/*model/:keyword', to: 'autocomplete#show', as: :autocomplete
end
