defmodule LocolBackend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder,
           only: [:id, :full_name, :email, :auth_user_id, :inserted_at, :updated_at]}
  schema "users" do
    field :full_name, :string
    field :email, :string
    field :auth_user_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :auth_user_id])
    |> validate_required([:full_name, :email])
    |> unique_constraint(:email)
  end
end
