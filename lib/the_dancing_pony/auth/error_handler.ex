defmodule TheDancingPonyWeb.Auth.ErrorHandler do
  use Phoenix.Controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_resp_content_type("application/json")
    |> json(%{error: reason_to_error_message(type, reason)})
  end

  defp reason_to_error_message(:unauthenticated, _reason), do: "Authentication failed"
  defp reason_to_error_message(:forbidden, _reason), do: "Forbidden access"
  defp reason_to_error_message(_, _), do: "Access denied"
end
