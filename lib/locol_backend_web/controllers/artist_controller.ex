defmodule LocolBackendWeb.ArtistController do
  use LocolBackendWeb, :controller

  alias LocolBackend.Artists
  alias LocolBackend.Artists.Artist

  def index(conn, params) do
    artists =
      case params["city"] do
        nil -> Artists.list_artists()
        city -> Artists.list_artists_by_city(city)
      end

    json(conn, artists)
  end

  def show(conn, %{"id" => id}) do
    artist = Artists.get_artist!(id)
    json(conn, artist)
  end

  def create(conn, %{"artist" => artist_params}) do
    case Artists.create_artist(artist_params) do
      {:ok, %Artist{} = artist} ->
        conn
        |> put_status(:created)
        |> json(artist)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "artist" => artist_params}) do
    artist = Artists.get_artist!(id)

    case Artists.update_artist(artist, artist_params) do
      {:ok, %Artist{} = artist} ->
        json(conn, artist)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    artist = Artists.get_artist!(id)

    with {:ok, %Artist{}} <- Artists.delete_artist(artist) do
      send_resp(conn, :no_content, "")
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
