defmodule TheDancingPony.Auth.Guardian do
  use Guardian, otp_app: :the_dancing_pony

  def subject_for_token(user, _claims) do
    # You can use any string value here, such as a user id.
    {:ok, "User:#{user.id}"}
  end

  def resource_from_claims(claims) do
    # Here you find the user from the claims, typically using the user id.
    id = claims["sub"] |> String.replace("User:", "")
    user = TheDancingPony.Repo.get(TheDancingPony.Accounts.User, id)
    {:ok, user}
  end
end
