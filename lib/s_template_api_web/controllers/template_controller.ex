defmodule STemplateAPIWeb.TemplateController do
  use STemplateAPIWeb, :controller

  alias STemplateAPI.Templates
  alias STemplateAPI.Templates.Template
  alias STemplateAPIWeb.Auth.Guardian

  action_fallback STemplateAPIWeb.FallbackController

  def index(conn, _params) do
    allowed_organization_ids =
      conn
      |> Guardian.allowed_organization_ids()

    templates =
      [organization_ids: allowed_organization_ids]
      |> Templates.list_templates()

    render(conn, :index, templates: templates)
  end

  def create(conn, %{"template" => template_params}) do
    with {:ok, %Template{} = template} <- Templates.create_template(template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/templates/#{template}")
      |> render(:show, template: template)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Template{} = template} <- Templates.get_template(id),
         {:ok, _} <- Guardian.allowed?(conn, template) do
      render(conn, :show, template: template)
    end
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    with {:ok, template} <- Templates.get_template(id),
         org_id = template_params |> Map.get("organization_id", template.organization_id),
         template <- Map.put(template, :organization_id, org_id),
         {:ok, _} <- Guardian.allowed?(conn, template),
         {:ok, %Template{} = template} <- Templates.update_template(template, template_params) do
      render(conn, :show, template: template)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, template} <- Templates.get_template(id),
         {:ok, _} <- Guardian.allowed?(conn, template),
         {:ok, %Template{}} <- Templates.delete_template(template) do
      send_resp(conn, :no_content, "")
    end
  end
end
