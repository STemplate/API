defmodule STemplateAPIWeb.TemplateController do
  use STemplateAPIWeb, :controller

  alias STemplateAPI.Templates
  alias STemplateAPI.Templates.Template

  action_fallback STemplateAPIWeb.FallbackController

  def index(conn, _params) do
    templates = Templates.list_templates()
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
    with {:ok, %Template{} = template} <- Templates.get_template(id) do
      render(conn, :show, template: template)
    end
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    with {:ok, template} <- Templates.get_template(id),
         {:ok, %Template{} = template} <- Templates.update_template(template, template_params) do
      render(conn, :show, template: template)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, template} <- Templates.get_template(id),
         {:ok, %Template{}} <- Templates.delete_template(template) do
      send_resp(conn, :no_content, "")
    end
  end
end
