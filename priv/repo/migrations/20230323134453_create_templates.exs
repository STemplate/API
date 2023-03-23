defmodule STemplateAPI.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :template, :string
      add :enabled, :boolean, default: false, null: false
      add :labels, {:array, :string}
      add :type, :string

      timestamps()
    end
  end
end
