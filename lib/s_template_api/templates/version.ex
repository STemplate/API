defmodule STemplateAPI.Templates.Version do
  @moduledoc """
  Track versions of templates. Each change will create a record to be able to rollback.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias STemplateAPI.Templates.Template

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "versions" do
    field :content, :string

    belongs_to :template, Template

    timestamps()
  end

  @doc false
  def changeset(version, attrs) do
    version
    |> cast(attrs, [:content, :template_id])
    |> validate_required([:content, :template_id])
  end
end
