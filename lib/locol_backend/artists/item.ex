defmodule LocolBackend.Artists.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :name,
             :price_cents,
             :count,
             :images,
             :artist_id,
             :inserted_at,
             :updated_at
           ]}
  schema "items" do
    field :name, :string
    field :price_cents, :integer
    field :count, :integer
    field :images, {:array, :string}

    belongs_to :artist, LocolBackend.Artists.Artist, type: :id

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :price_cents, :count, :images, :artist_id])
    |> validate_required([:name, :price_cents, :count, :artist_id])
  end
end
