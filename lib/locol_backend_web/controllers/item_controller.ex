defmodule LocolBackendWeb.ItemController do
  use LocolBackendWeb, :controller

  alias LocolBackend.Artists
  alias LocolBackend.Artists.Item

  def index(conn, _params) do
    items = Artists.list_items()
    json(conn, items)
  end

  def show(conn, %{"id" => id}) do
    item = Artists.get_item!(id)
    json(conn, item)
  end

  def create(conn, %{"item" => item_params}) do
    case Artists.create_item(item_params) do
      {:ok, %Item{} = item} ->
        conn
        |> put_status(:created)
        |> json(item)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Artists.get_item!(id)

    case Artists.update_item(item, item_params) do
      {:ok, %Item{} = item} ->
        json(conn, item)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Artists.get_item!(id)

    with {:ok, %Item{}} <- Artists.delete_item(item) do
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
