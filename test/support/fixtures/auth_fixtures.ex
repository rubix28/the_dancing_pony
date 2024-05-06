defmodule TheDancingPony.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TheDancingPony.Auth` context.
  """

  @doc """
  Generate a unique user nickname.
  """
  def unique_user_nickname do
    "some nickname#{System.unique_integer([:positive])}"
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    # Merge default attributes with those passed to the function
    # If `nickname` is provided in `attrs`, it will override the generated one due to Map.merge/2
    user_attrs =
      %{
        nickname: unique_user_nickname(),
        password: "password"
      }
      |> Map.merge(attrs)

    {:ok, user} = TheDancingPony.Auth.create_user(user_attrs)

    user
  end
end
