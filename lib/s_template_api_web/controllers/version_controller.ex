defmodule STemplateAPIWeb.VersionController do
  use STemplateAPIWeb, :controller

  alias STemplateAPI.{Templates, Repo}
  alias STemplateAPI.Templates.Version

  action_fallback STemplateAPIWeb.FallbackController

  def index(conn, %{"template_id" => id}) do
    with {:ok, template} <- Templates.get_template(id),
         template <- template |> Repo.preload(:versions) do
      render(conn, :index, versions: template.versions)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Version{} = version} <- Templates.get_version(id) do
      render(conn, :show, version: version)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, version} <- Templates.get_version(id),
         {:ok, %Version{}} <- Templates.delete_version(version) do
      send_resp(conn, :no_content, "")
    end
  end
end
