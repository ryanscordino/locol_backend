defmodule LocolBackendWeb.Plugs.Auth do
  import Plug.Conn
  alias LocolBackend.{Users, Artists}

  @supabase_jwt_secret System.get_env("SUPABASE_JWT_SECRET") |> to_string()

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- verify_jwt(token),
         {:ok, user, role} <- load_user(claims) do
      conn
      |> assign(:current_user, user)
      |> assign(:role, role)
    else
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    |> halt()
  end

  defp verify_jwt(token) do
    signer = Joken.Signer.create("HS256", @supabase_jwt_secret)
    case Joken.verify(token, signer) do
      {:ok, claims} -> {:ok, claims}
      _ -> {:error, :invalid_token}
    end
  end

  defp load_user(%{"sub" => auth_user_id}) do
    case Artists.get_artist_by_auth(auth_user_id) do
      nil ->
        case Users.get_user_by_auth(auth_user_id) do
          nil -> {:error, :not_found}
          user -> {:ok, user, :user}
        end
      artist -> {:ok, artist, :artist}
    end
  end
end
