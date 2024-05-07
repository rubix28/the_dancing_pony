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
        name: "Cram",
        description: "Dense bread used for long journeys",
        price: Decimal.new("9.00")
      })
      |> TheDancingPony.Menu.create_dish()

    dish
  end
end
