defmodule TheDancingPony.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :value, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :dish_id, references(:dishes, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:ratings, [:user_id, :dish_id], name: :user_dish_rating_unique)
  end
end
