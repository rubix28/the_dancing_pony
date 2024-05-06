defmodule TheDancingPonyWeb.UserController do
  use TheDancingPonyWeb, :controller
  alias TheDancingPony.Auth
  alias TheDancingPony.Auth.Guardian
  alias TheDancingPonyWeb.ErrorJSON

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{jwt: jwt})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: ErrorJSON.translate_errors(changeset)
        })
    end
  end
end
