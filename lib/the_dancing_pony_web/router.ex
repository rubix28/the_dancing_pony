defmodule TheDancingPonyWeb.Router do
  use TheDancingPonyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"

    plug Guardian.Plug.LoadResource,
      on_failure: {TheDancingPonyWeb.Auth.ErrorHandler, :auth_error}
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

    # Add your protected routes here
    # Example: get "/protected", SomeProtectedController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:the_dancing_pony, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TheDancingPonyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
