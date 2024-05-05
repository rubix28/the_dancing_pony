defmodule TheDancingPony.Repo do
  use Ecto.Repo,
    otp_app: :the_dancing_pony,
    adapter: Ecto.Adapters.Postgres
end
