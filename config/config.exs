# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :the_dancing_pony,
  ecto_repos: [TheDancingPony.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :the_dancing_pony, TheDancingPonyWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TheDancingPonyWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TheDancingPony.PubSub,
  live_view: [signing_salt: "bmd7SpOK"]

config :the_dancing_pony, TheDancingPony.Auth.Guardian,
  issuer: "the_dancing_pony",
  # Ideally, we don't use a fallback key here. However, I won't assume whoever is reading this
  # has their environment variables set up ahead of time :)
  secret_key:
    System.get_env("GUARDIAN_SECRET_KEY") ||
      "YSz10i1xM9SmUG0MfiCMiqrR3/EzgtBKjtsLra3Ib6nA7LeyPzZoBFogoX5wOPKh"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :the_dancing_pony, TheDancingPony.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
