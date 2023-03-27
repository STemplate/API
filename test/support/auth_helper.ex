defmodule STemplateAPIWeb.Auth.AuthHelper do
  @moduledoc """
  Helper to build conn with authorization header.
  """
  import Plug.Conn

  alias STemplateAPI.Management.Organization
  alias STemplateAPIWeb.Auth.Guardian

  @doc """
  Add a valid authorization header to the connection.

  ## Examples

    iex> conn |> AuthHelper.with_valid_authorization_header(org_id)
    conn
    iex> conn |> AuthHelper.with_valid_authorization_header()
    conn

  ### Example of use in a test
    alias STemplateAPIWeb.Auth.AuthHelper

    setup %{conn: conn} do
      conn =
        conn
        |> AuthHelper.with_valid_authorization_header()

      {:ok, conn: conn}
    end
  """
  def with_valid_authorization_header(
        conn,
        organization_id \\ "e281da89-3fa0-4487-9064-911ba0e83f1c"
      ) do
    conn |> create_with_valid_authorization_header(%Organization{id: organization_id})
  end

  defp create_with_valid_authorization_header(conn, organization) do
    {:ok, token, _} = Guardian.encode_and_sign(organization, %{})

    conn
    |> put_req_header("authorization", "Bearer " <> token)
    |> put_req_header("accept", "application/json")
  end
end
