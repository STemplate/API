defmodule STemplateAPI.Management.Organization do
  @moduledoc """
  The Organization context.

  This context is responsible for managing the organization, that is used
  to filter the data, and store common parameters to templates.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Encryption.Hashing

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :enabled, :boolean, default: false
    field :external_id, :string
    field :name, :string
    field :properties, :map
    field :parent_organization_id, :binary_id
    field :api_key, :binary, virtual: true
    field :api_key_hash, :binary

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :enabled, :properties, :api_key, :external_id, :parent_organization_id])
    |> validate_required([:name, :enabled, :properties])
    |> hash_api_key()
    |> unique_constraint(:api_key_hash)
  end

  defp hash_api_key(%Changeset{valid?: true, changes: %{api_key: api_key}} = changeset),
    do: changeset |> put_change(:api_key_hash, Hashing.hash(api_key))

  defp hash_api_key(changeset), do: changeset
end
