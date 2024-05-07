defmodule TheDancingPony.Repo.Migrations.CreateDishes do
  use Ecto.Migration

  def change do
    create table(:dishes) do
      add :name, :string
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2

      timestamps(type: :utc_datetime)
    end

    create unique_index(:dishes, [:name], name: :dish_name_unique)
    create unique_index(:dishes, [:description], name: :dish_description_unique)
  end
end
