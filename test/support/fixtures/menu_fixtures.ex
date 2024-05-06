defmodule TheDancingPony.MenuFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TheDancingPony.Menu` context.
  """

  @doc """
  Generate a dish.
  """
  def dish_fixture(attrs \\ %{}) do
    {:ok, dish} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.50"
      })
      |> TheDancingPony.Menu.create_dish()

    dish
  end
end
