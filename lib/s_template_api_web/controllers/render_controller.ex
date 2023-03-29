defmodule STemplateAPIWeb.RenderController do
  @moduledoc """
  Render a template by name with the params
  """

  use STemplateAPIWeb, :controller

  alias STemplateAPI.Liquid.Render

  action_fallback STemplateAPIWeb.FallbackController

  def create(conn, %{"name" => name, "params" => params}) do
    with template <- name |> STemplateAPI.Templates.get_template_by_name(),
         {:ok, result} <- template |> Render.call(params) do
      conn
      |> put_status(:ok)
      |> render("render.json", result: result)
    end
  end
end
