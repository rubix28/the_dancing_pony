defmodule TheDancingPonyWeb.UserController do
  use TheDancingPonyWeb, :controller
  alias TheDancingPony.Auth
  alias TheDancingPony.Auth.Guardian
  alias TheDancingPonyWeb.ResponseHelper

  # Creates a user account, and provides a JWT token back if the operation
  # is successful
  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{jwt: jwt})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: ResponseHelper.translate_errors(changeset)
        })
    end
  end
end
