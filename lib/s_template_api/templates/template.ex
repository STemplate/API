defmodule STemplateAPI.Templates.Template do
  @moduledoc """
  The Template schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias STemplateAPI.Management.Organization
  alias STemplateAPI.Templates.Version

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "templates" do
    field :enabled, :boolean, default: false
    field :labels, {:array, :string}
    field :name, :string
    field :template, :string
    field :type, :string

    has_many :versions, Version
    belongs_to :organization, Organization

    timestamps()
  end

  @required ~w(name template enabled labels type organization_id)a

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint([:name, :organization_id])
  end
end
