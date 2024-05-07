defmodule TheDancingPony.Menu.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :value, :integer
    belongs_to :user, TheDancingPony.Auth.User
    belongs_to :dish, TheDancingPony.Menu.Dish

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:value, :user_id, :dish_id])
    |> validate_required([:value, :user_id, :dish_id])
    # Assuming ratings are between 1 and 5
    |> validate_rating_value()
    |> unique_constraint([:user_id, :dish_id], name: :user_dish_rating_unique)
  end

  defp validate_rating_value(changeset) do
    value = get_field(changeset, :value)

    if value in 1..5 do
      changeset
    else
      add_error(changeset, :value, "Must be between 1 and 5")
    end
  end
end
