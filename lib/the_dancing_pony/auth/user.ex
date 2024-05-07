defmodule TheDancingPony.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :nickname, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :password])
    |> validate_required([:nickname, :password])
    # TODO: More secure requirements here
    |> validate_length(:password, min: 8)
    |> unique_constraint(:nickname)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    hash = Bcrypt.hash_pwd_salt(password)
    put_change(changeset, :password_hash, hash)
  end

  defp put_password_hash(changeset), do: changeset
end
