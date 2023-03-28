defmodule STemplateAPIWeb.OrganizationController do
  @moduledoc false

  use STemplateAPIWeb, :controller

  alias STemplateAPI.Management
  alias STemplateAPI.Management.Organization
  alias STemplateAPIWeb.Auth.Guardian

  action_fallback STemplateAPIWeb.FallbackController

  def index(conn, _params) do
    allowed_organization_ids =
      conn
      |> Guardian.allowed_organization_ids()

    organizations =
      [ids: allowed_organization_ids]
      |> Management.list_organizations()

    render(conn, :index, organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <-
           Management.create_organization(organization_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organizations/#{organization}")
      |> render(:show, organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, organization} <- Management.get_organization(id),
         {:ok, _} <- Guardian.allowed?(conn, organization) do
      render(conn, :show, organization: organization)
    end
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    with {:ok, organization} <- Management.get_organization(id),
         {:ok, _} <- Guardian.allowed?(conn, organization),
         {:ok, %Organization{} = organization} <-
           Management.update_organization(organization, organization_params) do
      render(conn, :show, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, organization} <- Management.get_organization(id),
         {:ok, _} <- Guardian.allowed?(conn, organization),
         {:ok, %Organization{}} <- Management.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
