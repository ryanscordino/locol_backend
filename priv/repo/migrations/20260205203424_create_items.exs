defmodule LocolBackend.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :price_cents, :integer, null: false
      add :count, :integer, null: false
      add :images, {:array, :string}
      add :artist_id, references(:artists, type: :bigint, on_delete: :delete_all)

      timestamps()
    end

    create index(:items, [:artist_id])
  end
end
