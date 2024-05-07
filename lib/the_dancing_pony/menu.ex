defmodule TheDancingPony.Menu do
  @moduledoc """
  The Menu context.
  """

  import Ecto.Query, warn: false
  alias TheDancingPony.Repo

  alias TheDancingPony.Menu.Dish
  alias TheDancingPony.Menu.Rating

  @doc """
  Returns the list of dishes.
  Optionally provide a name parameter to filter by name (case insensitive).

  ## Examples

      iex> list_dishes()
      [%Dish{}, ...]

      iex> list_dishes(%{name: "cram"})
      [%Dish{name: "Cram", ...}, ...]
  """
  def list_dishes(params \\ %{}) do
    Dish
    |> maybe_filter_by_name(params["name"])
    |> Repo.all()
  end

  @doc """
  Gets a single dish.

  Raises `Ecto.NoResultsError` if the Dish does not exist.

  ## Examples

      iex> get_dish!(123)
      %Dish{}

      iex> get_dish!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dish!(id), do: Repo.get!(Dish, id)

  @doc """
  Returns a boolean indicating if a rating exists for a given user and dish.

  ## Examples

      iex> check_rating_exists?(123, 456)
      true
  """
  def check_rating_exists?(user_id, dish_id) when not is_nil(user_id) and not is_nil(dish_id) do
    query =
      from r in Rating,
        where: r.user_id == ^user_id and r.dish_id == ^dish_id

    case Repo.exists?(query) do
      true -> {:ok, :exists}
      false -> {:ok, :not_exists}
    end
  end

  def check_rating_exists?(_, _), do: false

  @doc """
  Creates a dish.

  ## Examples

      iex> create_dish(%{field: value})
      {:ok, %Dish{}}

      iex> create_dish(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dish(attrs \\ %{}) do
    %Dish{}
    |> Dish.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dish.

  ## Examples

      iex> update_dish(dish, %{field: new_value})
      {:ok, %Dish{}}

      iex> update_dish(dish, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dish(%Dish{} = dish, attrs) do
    dish
    |> Dish.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dish.

  ## Examples

      iex> delete_dish(dish)
      {:ok, %Dish{}}

      iex> delete_dish(dish)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dish(%Dish{} = dish) do
    Repo.delete(dish)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dish changes.

  ## Examples

      iex> change_dish(dish)
      %Ecto.Changeset{data: %Dish{}}

  """
  def change_dish(%Dish{} = dish, attrs \\ %{}) do
    Dish.changeset(dish, attrs)
  end

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_rating(attrs \\ %{}) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  # Helper function to conditionally apply name filter
  defp maybe_filter_by_name(query, nil), do: query

  defp maybe_filter_by_name(query, name) do
    from d in query,
      where: ilike(d.name, ^"%#{name}%")
  end
end
