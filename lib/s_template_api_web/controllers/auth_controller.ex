defmodule STemplateAPIWeb.AuthController do
  @moduledoc """
  The Auth controller.
  Generate the JWT token for the organization.
  """
  use STemplateAPIWeb, :controller

  action_fallback STemplateAPIWeb.FallbackController

  def create(conn, %{"api_key" => api_key}) do
    with {:ok, organization, jwt} <- STemplateAPIWeb.Auth.Guardian.authenticate(api_key) do
      conn
      |> put_status(:created)
      |> put_resp_header("authorization", jwt)
      |> render("show.json", organization: organization)
    end
  end
end
