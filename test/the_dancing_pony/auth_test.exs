defmodule TheDancingPony.AuthTest do
  use TheDancingPony.DataCase

  alias TheDancingPony.Auth
  alias TheDancingPony.Auth.User

  import TheDancingPony.AuthFixtures

  @invalid_attrs %{nickname: nil}

  test "list_users/0 returns all users" do
    user = user_fixture()
    assert Enum.map(Auth.list_users(), &exclude_password/1) == [exclude_password(user)]
  end

  test "get_user!/1 returns the user with given id" do
    user = user_fixture()
    assert exclude_password(Auth.get_user!(user.id)) == exclude_password(user)
  end

  test "create_user/1 with valid data creates a user" do
    valid_attrs = %{nickname: "some nickname", password: "password"}

    assert {:ok, %User{} = user} = Auth.create_user(valid_attrs)
    assert user.nickname == "some nickname"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = user_fixture()
    update_attrs = %{nickname: "some updated nickname"}

    assert {:ok, %User{} = updated_user} = Auth.update_user(user, update_attrs)
    assert exclude_password(updated_user) == exclude_password(Auth.get_user!(updated_user.id))
    assert updated_user.nickname == "some updated nickname"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = user_fixture()
    assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
    assert exclude_password(user) == exclude_password(Auth.get_user!(user.id))
  end

  test "delete_user/1 deletes the user" do
    user = user_fixture()
    assert {:ok, %User{}} = Auth.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = user_fixture()
    assert %Ecto.Changeset{} = Auth.change_user(user)
  end

  defp exclude_password(user) do
    Map.delete(user, :password)
  end
end
