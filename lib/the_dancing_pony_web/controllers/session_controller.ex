# lib/the_dancing_pony_web/controllers/session_controller.ex
defmodule TheDancingPonyWeb.SessionController do
  use TheDancingPonyWeb, :controller
  alias TheDancingPony.Auth
  alias TheDancingPony.Auth.Guardian

  def create(conn, %{"nickname" => nickname, "password" => password}) do
    with {:ok, user} <- Auth.authenticate_user(nickname, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      json(conn, %{jwt: token})
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end
end
