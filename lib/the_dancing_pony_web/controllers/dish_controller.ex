defmodule TheDancingPonyWeb.DishController do
  use TheDancingPonyWeb, :controller
  alias TheDancingPony.Menu
  alias TheDancingPonyWeb.ResponseHelper

  # List all dishes or filter by name if a 'name' parameter is provided
  def index(conn, params) do
    dishes = Menu.list_dishes(params)
    json(conn, %{data: Enum.map(dishes, &dish_to_map/1)})
  end

  # Show a single dish by ID
  def show(conn, %{"id" => id}) do
    dish = Menu.get_dish!(id)
    json(conn, %{data: dish_to_map(dish)})
  end

  # Create a new dish
  def create(conn, %{"dish" => dish_params}) do
    with {:ok, dish} <- Menu.create_dish(dish_params) do
      conn
      |> put_status(:created)
      |> json(%{data: dish_to_map(dish)})
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: ResponseHelper.translate_errors(changeset)})
    end
  end

  # Update an existing dish
  def update(conn, %{"id" => id, "dish" => dish_params}) do
    dish = Menu.get_dish!(id)

    with {:ok, dish} <- Menu.update_dish(dish, dish_params) do
      json(conn, %{data: dish_to_map(dish)})
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: ResponseHelper.translate_errors(changeset)})
    end
  end

  # Delete a dish
  def delete(conn, %{"id" => id}) do
    dish = Menu.get_dish!(id)

    with {:ok, _dish} <- Menu.delete_dish(dish) do
      send_resp(conn, :no_content, "")
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: ResponseHelper.translate_errors(changeset)})
    end
  end

  # Helper function to convert a dish to a map
  defp dish_to_map(dish) do
    %{
      id: dish.id,
      name: dish.name,
      description: dish.description,
      price: dish.price
    }
  end
end
