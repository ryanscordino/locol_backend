defmodule LocolBackend.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :full_name, :string, null: false
      add :username, :string, null: false
      add :location, :string, null: false
      add :art_type, :string, null: false
      add :instagram_account, :string
      add :auth_user_id, :uuid

      timestamps()
    end

    create unique_index(:artists, [:username])
  end
end
