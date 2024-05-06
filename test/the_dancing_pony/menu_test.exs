defmodule TheDancingPony.MenuTest do
  use TheDancingPony.DataCase

  alias TheDancingPony.Menu

  describe "dishes" do
    alias TheDancingPony.Menu.Dish

    import TheDancingPony.MenuFixtures

    @invalid_attrs %{name: nil, description: nil, price: nil}

    test "list_dishes/0 returns all dishes" do
      dish = dish_fixture()
      assert Menu.list_dishes() == [dish]
    end

    test "get_dish!/1 returns the dish with given id" do
      dish = dish_fixture()
      assert Menu.get_dish!(dish.id) == dish
    end

    test "create_dish/1 with valid data creates a dish" do
      valid_attrs = %{name: "some name", description: "some description", price: "120.5"}

      assert {:ok, %Dish{} = dish} = Menu.create_dish(valid_attrs)
      assert dish.name == "some name"
      assert dish.description == "some description"
      assert dish.price == Decimal.new("120.5")
    end

    test "create_dish/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_dish(@invalid_attrs)
    end

    test "update_dish/2 with valid data updates the dish" do
      dish = dish_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7"
      }

      assert {:ok, %Dish{} = dish} = Menu.update_dish(dish, update_attrs)
      assert dish.name == "some updated name"
      assert dish.description == "some updated description"
      assert dish.price == Decimal.new("456.7")
    end

    test "update_dish/2 with invalid data returns error changeset" do
      dish = dish_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_dish(dish, @invalid_attrs)
      assert dish == Menu.get_dish!(dish.id)
    end

    test "delete_dish/1 deletes the dish" do
      dish = dish_fixture()
      assert {:ok, %Dish{}} = Menu.delete_dish(dish)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_dish!(dish.id) end
    end

    test "change_dish/1 returns a dish changeset" do
      dish = dish_fixture()
      assert %Ecto.Changeset{} = Menu.change_dish(dish)
    end
  end
end
