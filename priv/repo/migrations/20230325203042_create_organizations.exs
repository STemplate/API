defmodule STemplateAPI.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :external_id, :string
      add :enabled, :boolean, default: false, null: false
      add :properties, :map, null: false, default: %{}
      add :api_key_hash, :binary

      add :parent_organization_id,
          references(:organizations, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:organizations, [:name])
    create unique_index(:organizations, [:api_key_hash])
    create index(:organizations, [:parent_organization_id])
  end
end
