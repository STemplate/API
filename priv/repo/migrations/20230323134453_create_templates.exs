defmodule STemplateAPI.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :template, :string, null: false, default: ""
      add :enabled, :boolean, default: false, null: false
      add :labels, {:array, :string}, null: false, default: []
      add :type, :string, null: false, default: "text/plain"
      add :organization_id, :uuid, null: false

      timestamps()
    end

    create index(:templates, :organization_id)
    create unique_index(:templates, [:name, :organization_id])
  end
end
