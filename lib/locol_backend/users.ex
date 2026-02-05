defmodule LocolBackend.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias LocolBackend.Repo

  alias LocolBackend.Users.User

  # LIST
  def list_users do
    Repo.all(User)
  end

  # GET BY ID
  def get_user!(id), do: Repo.get!(User, id)

  # GET BY AUTH USER ID
  def get_user_by_auth(auth_user_id) do
    Repo.get_by(User, auth_user_id: auth_user_id)
  end

  # CREATE
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # UPDATE
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # DELETE
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
