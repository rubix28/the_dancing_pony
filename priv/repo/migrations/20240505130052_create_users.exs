defmodule TheDancingPony.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      add :password_hash, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:nickname], name: :user_nickname_unique)
  end
end
