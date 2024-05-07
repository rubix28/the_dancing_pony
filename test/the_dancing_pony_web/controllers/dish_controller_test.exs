defmodule TheDancingPonyWeb.DishControllerTest do
  use TheDancingPonyWeb.ConnCase

  import TheDancingPony.AuthFixtures

  alias TheDancingPony.Menu

  describe "Dish management" do
    setup %{conn: conn} do
      user = user_fixture()
      {:ok, token, _} = TheDancingPony.Auth.Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, dish} =
        Menu.create_dish(%{
          "name" => "Lembas",
          "description" => "Elven bread",
          "price" => "5.00"
        })

      Menu.create_dish(%{
        "name" => "Miruvor",
        "description" => "Revitalizing drink",
        "price" => "7.00"
      })

      {:ok, conn: conn, dish: dish, user: user}
    end

    test "lists all dishes", %{conn: conn} do
      response = get(conn, Routes.dish_path(conn, :index))
      assert json_response(response, 200)
    end

    test "returns dishes filtered by name", %{conn: conn} do
      conn = get(conn, Routes.dish_path(conn, :index, %{"name" => "Lembas"}))
      results = json_response(conn, 200)["data"]
      assert length(results) == 1
      assert Enum.all?(results, fn dish -> dish["name"] == "Lembas" end)
    end

    test "shows chosen dish", %{conn: conn, dish: dish} do
      response = get(conn, Routes.dish_path(conn, :show, dish.id))

      assert json_response(response, 200)["data"] == %{
               "id" => dish.id,
               "name" => dish.name,
               "description" => dish.description,
               "price" => Decimal.to_string(dish.price)
             }
    end

    test "creates a dish", %{conn: conn} do
      params = %{
        "dish" => %{
          "name" => "Cram",
          "description" => "Dense bread used for long journeys",
          "price" => "3.50"
        }
      }

      response = post(conn, Routes.dish_path(conn, :create), params)
      assert json_response(response, 201)["data"]["name"] == "Cram"
    end

    test "updates chosen dish", %{conn: conn, dish: dish} do
      updates = %{"name" => "Updated Lembas"}
      response = put(conn, Routes.dish_path(conn, :update, dish.id), %{"dish" => updates})
      assert json_response(response, 200)["data"]["name"] == "Updated Lembas"
    end

    test "deletes chosen dish", %{conn: conn, dish: dish} do
      response = delete(conn, Routes.dish_path(conn, :delete, dish.id))
      assert response(response, 204)
    end
  end
end
