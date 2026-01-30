defmodule LocolBackend.Repo do
  use Ecto.Repo,
    otp_app: :locol_backend,
    adapter: Ecto.Adapters.Postgres
end
