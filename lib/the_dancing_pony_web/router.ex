defmodule TheDancingPonyWeb.Router do
  use TheDancingPonyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug TheDancingPony.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Public routes
  scope "/api", TheDancingPonyWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/sessions", SessionController, :create
  end

  # Protected routes
  scope "/api", TheDancingPonyWeb do
    pipe_through [:api, :api_auth]

    resources "/dishes", DishController, except: [:new, :edit]
    resources "/rate", RatingController, only: [:create]
  end
end
