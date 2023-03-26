defmodule STemplateAPIWeb.OrganizationJSON do
  alias STemplateAPI.Management.Organization

  @doc """
  Renders a list of organizations.
  """
  def index(%{organizations: organizations}) do
    %{data: for(organization <- organizations, do: data(organization))}
  end

  @doc """
  Renders a single organization.
  """
  def show(%{organization: organization}) do
    %{data: data(organization)}
  end

  defp data(%Organization{} = organization) do
    %{
      id: organization.id,
      name: organization.name,
      external_id: organization.external_id,
      enabled: organization.enabled,
      properties: organization.properties
    }
  end
end
