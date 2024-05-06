defmodule TheDancingPony.Menu.Dish do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dishes" do
    field :name, :string
    field :description, :string
    field :price, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(dish, attrs) do
    dish
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :description, :price])
    |> unique_constraint(:name)
    |> unique_constraint(:description)
  end
end
