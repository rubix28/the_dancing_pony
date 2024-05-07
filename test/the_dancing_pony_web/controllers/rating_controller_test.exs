defmodule TheDancingPonyWeb.RatingControllerTest do
  use TheDancingPonyWeb.ConnCase

  import TheDancingPony.AuthFixtures

  alias TheDancingPony.Menu
  alias TheDancingPony.Auth
  alias TheDancingPony.Auth.Guardian

  describe "Rating management" do
    setup %{conn: conn} do
      user = user_fixture()
      {:ok, token, _full_claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      # Create a dish
      {:ok, dish} =
        Menu.create_dish(%{
          name: "Lembas",
          description: "Elven bread",
          price: "5.00"
        })

      {:ok, conn: conn, dish: dish, token: token}
    end

    test "allows a user to rate a dish", %{conn: conn, dish: dish} do
      params = %{value: 5, dish_id: dish.id}
      conn = post(conn, Routes.rating_path(conn, :create), rating: params)
      assert json_response(conn, 201)["data"]["value"] == 5
    end

    test "rejects a rating value outside the range of 1 to 5", %{conn: conn, dish: dish} do
      invalid_params = %{"value" => 6, "dish_id" => dish.id}
      conn = post(conn, Routes.rating_path(conn, :create), rating: invalid_params)

      assert json_response(conn, 422)["errors"]["value"] == ["Must be between 1 and 5"]
    end

    test "prevents a user from rating the same dish twice", %{conn: conn, dish: dish} do
      params = %{"value" => 3, "dish_id" => dish.id}

      post(conn, Routes.rating_path(conn, :create), rating: params)
      conn = post(conn, Routes.rating_path(conn, :create), rating: params)

      assert json_response(conn, 422)["errors"] == ["User has already rated this dish"]
    end

    test "prevents Sméagol from rating dishes", %{conn: conn, dish: dish} do
      {:ok, smeagol} = Auth.create_user(%{nickname: "Smeagol", password: "precious"})
      {:ok, token, _full_claims} = Guardian.encode_and_sign(smeagol)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      params = %{"value" => 1, "dish_id" => dish.id}
      conn = post(conn, Routes.rating_path(conn, :create), rating: params)
      assert json_response(conn, 403)["errors"] == ["Smeagol is not allowed to rate dishes"]
    end
  end
end
