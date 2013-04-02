Maria::Engine.routes.draw do
  match '/pages/:brand(/:name)', to: 'pages#show'
end
