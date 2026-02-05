defmodule LocolBackend.Artists.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :full_name,
             :username,
             :location,
             :art_type,
             :instagram_account,
             :auth_user_id,
             :inserted_at,
             :updated_at
           ]}
  schema "artists" do
    field :full_name, :string
    field :username, :string
    field :location, :string
    field :art_type, :string
    field :instagram_account, :string
    field :auth_user_id, Ecto.UUID

    has_many :items, LocolBackend.Artists.Item

    timestamps()
  end

  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [
      :full_name,
      :username,
      :location,
      :art_type,
      :instagram_account,
      :auth_user_id
    ])
    |> validate_required([:full_name, :username, :location, :art_type])
    |> unique_constraint(:username)
  end
end
