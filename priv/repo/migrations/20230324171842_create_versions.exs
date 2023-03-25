defmodule STemplateAPI.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :template_id, references(:templates, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:versions, [:template_id])
  end
end
