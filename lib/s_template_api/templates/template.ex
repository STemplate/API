defmodule STemplateAPI.Templates.Template do
  @moduledoc """
  The Template schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "templates" do
    field :enabled, :boolean, default: false
    field :labels, {:array, :string}
    field :name, :string
    field :template, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :template, :enabled, :labels, :type])
    |> validate_required([:name, :template, :enabled, :labels, :type])
  end
end
