# test/the_dancing_pony_web/controllers/session_controller_test.exs
defmodule TheDancingPonyWeb.SessionControllerTest do
  use TheDancingPonyWeb.ConnCase

  import TheDancingPony.AuthFixtures

  describe "create session" do
    setup do
      user = user_fixture(%{nickname: "frodo"})
      {:ok, user: user}
    end

    test "responds with JWT on successful login", %{conn: conn} do
      params = %{nickname: "frodo", password: "password"}
      response = post(conn, Routes.session_path(conn, :create), params)
      assert json_response(response, 200)["jwt"]
    end

    test "responds with unauthorized on invalid credentials", %{conn: conn} do
      params = %{nickname: "frodo", password: "wrongpassword"}
      response = post(conn, Routes.session_path(conn, :create), params)
      assert json_response(response, 401)
    end
  end
end
