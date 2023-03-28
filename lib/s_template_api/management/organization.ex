defmodule STemplateAPI.Management.Organization do
  @moduledoc """
  The Organization context.

  This context is responsible for managing the organization, that is used
  to filter the data, and store common parameters to templates.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias STemplateAPI.Templates.Template
  alias Ecto.Changeset
  alias Encryption.Hashing

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :name, :string
    field :enabled, :boolean, default: false
    field :properties, :map

    field :external_id, :string
    field :parent_organization_id, :binary_id
    field :api_key, :binary, virtual: true
    field :api_key_hash, :binary

    has_many :templates, Template

    timestamps()
  end

  @optional ~w(api_key external_id parent_organization_id)a
  @required ~w(name enabled properties)a

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> hash_api_key()
    |> unique_constraint(:api_key_hash, name: :organizations_api_key_hash_index)
    |> unique_constraint(:name, name: :organizations_name_index)
    |> foreign_key_constraint(:parent_organization_id)
  end

  defp hash_api_key(%Changeset{valid?: true, changes: %{api_key: api_key}} = changeset),
    do: changeset |> put_change(:api_key_hash, Hashing.hash(api_key))

  defp hash_api_key(changeset), do: changeset
end
