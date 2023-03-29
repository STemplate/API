defmodule STemplateAPIWeb.LabelController do
  @moduledoc false

  use STemplateAPIWeb, :controller

  alias STemplateAPIWeb.Auth.Guardian
  alias Cache.LabelsCache
  alias STemplateAPI.Management.Organization

  action_fallback STemplateAPIWeb.FallbackController

  def index(conn, %{"organization_id" => id}) do
    with {:ok, _} <- Guardian.allowed?(conn, %Organization{id: id}),
         labels <- LabelsCache.get(id) do
      render(conn, :index, labels: labels)
    end
  end
end
