defmodule TheDancingPonyWeb.ResponseHelper do
  @moduledoc """
  Helper module for JSON responses to ensure consistency across the application.
  """

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
