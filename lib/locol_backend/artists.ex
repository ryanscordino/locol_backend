defmodule LocolBackend.Artists do
  import Ecto.Query, warn: false
  alias LocolBackend.Repo

  alias LocolBackend.Artists.{Artist, Item}

  # ARTISTS

  def list_artists do
    Repo.all(Artist)
  end

  def list_artists_by_city(city) do
    from(a in Artist, where: a.location == ^city)
    |> Repo.all()
  end

  def get_artist!(id), do: Repo.get!(Artist, id) |> Repo.preload(:items)

  def get_artist_by_auth(auth_user_id) do
    Repo.get_by(Artist, auth_user_id: auth_user_id)
  end

  def create_artist(attrs) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  # ITEMS

  def list_items do
    Repo.all(Item)
  end

  def get_item!(id), do: Repo.get!(Item, id)

  def get_item_by_auth(auth_user_id) do
    Repo.get_by(Item, auth_user_id: auth_user_id)
  end

  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end
end
