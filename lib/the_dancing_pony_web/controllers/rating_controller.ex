defmodule TheDancingPonyWeb.RatingController do
  use TheDancingPonyWeb, :controller

  alias TheDancingPonyWeb.ResponseHelper
  alias TheDancingPony.{Menu, Auth.Guardian}

  # Creates a rating for a dish, provided:
  #   1) The user is authenticated
  #   2) The user is not Smeagol
  #   3) The user hasn't already rated the dish
  #   4) The payload is in the correct format
  def create(conn, %{"rating" => rating_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    with user when not is_nil(user) <- current_user,
         %{is_smeagol: false} <- %{is_smeagol: String.downcase(user.nickname) == "smeagol"},
         {:ok, :not_exists} <- Menu.check_rating_exists?(user.id, rating_params["dish_id"]),
         {:ok, rating} <- Menu.create_rating(Map.put(rating_params, "user_id", user.id)) do
      conn
      |> put_status(:created)
      |> json(%{data: rating_to_map(rating)})
    else
      nil ->
        unauthorized_response(conn)

      # Handle Smeagol specifically
      %{is_smeagol: true} ->
        smeagol_restricted_response(conn)

      {:ok, :exists} ->
        already_rated_response(conn)

      {:error, changeset} ->
        error_response(conn, changeset)
    end
  end

  defp unauthorized_response(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{errors: ["No authenticated user"]})
    |> halt()
  end

  defp smeagol_restricted_response(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{errors: ["Smeagol is not allowed to rate dishes"]})
    |> halt()
  end

  defp already_rated_response(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: ["User has already rated this dish"]})
    |> halt()
  end

  defp error_response(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: ResponseHelper.translate_errors(changeset)})
  end

  # Helper function to convert a rating to a map
  defp rating_to_map(rating) do
    %{
      id: rating.id,
      user_id: rating.user_id,
      dish_id: rating.dish_id,
      value: rating.value
    }
  end
end
