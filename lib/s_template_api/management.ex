defmodule STemplateAPI.Management do
  @moduledoc """
  The Management context.
  """

  import Ecto.Query, warn: false
  alias Encryption.Hashing
  alias STemplateAPI.Repo

  alias STemplateAPI.Management.Organization

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations(filters \\ []) do
    from(o in Organization)
    |> filter_query(filters)
    |> Repo.all()
  end

  defp filter_query(query, []), do: query

  defp filter_query(query, ids: list) do
    query |> where([o], o.id in ^list)
  end

  @doc """
  Gets a single organization.

  ## Examples

      iex> get_organization(ff822bfa-3de4-4166-995a-22dbf579a5ce)
      {:ok, %Organization{}}

      iex> get_organization!(456)
      {:error, :not_found}

  """
  def get_organization(id) do
    case Repo.get(Organization, id) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @doc """
  Gets a single organization by api_key.

  ## Examples

    iex> Repo.get_organization_by_api_key("api_key")
    {:ok, %Organization{}}

  """
  def get_organization_by_api_key(api_key) do
    case Repo.get_by(Organization, api_key_hash: Hashing.hash(api_key)) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @doc """
  Gets all the descendant organization ids of a given organization.
  """
  def get_descendant_organization_ids(organization) do
    id = organization.id |> Ecto.UUID.dump!()

    query =
      from o in fragment("organization_descendants(?)", ^id),
        select: o.id

    {:ok, query |> Repo.all() |> Enum.map(&Ecto.UUID.load!/1)}
  end

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end
end
