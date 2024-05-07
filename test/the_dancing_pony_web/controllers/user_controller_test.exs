# test/the_dancing_pony_web/controllers/user_controller_test.exs
defmodule TheDancingPonyWeb.UserControllerTest do
  use TheDancingPonyWeb.ConnCase

  describe "create user" do
    test "responds with JWT on successful registration", %{conn: conn} do
      params = %{user: %{nickname: "frodo", password: "password123"}}
      response = post(conn, Routes.user_path(conn, :create), params)
      assert json_response(response, 200)["jwt"]
    end

    test "responds with errors on failed registration", %{conn: conn} do
      params = %{user: %{nickname: "", password: "password123"}}
      response = post(conn, Routes.user_path(conn, :create), params)
      assert json_response(response, 422)["errors"]
    end

    test "makes you use a 'secure' password", %{conn: conn} do
      params = %{user: %{nickname: "", password: "little"}}
      response = post(conn, Routes.user_path(conn, :create), params)
      assert json_response(response, 422)["errors"]
    end
  end
end
