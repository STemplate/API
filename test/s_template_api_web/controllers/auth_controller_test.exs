defmodule STemplateAPIWeb.AuthControllerTest do
  use STemplateAPIWeb.ConnCase

  alias STemplateAPI.Management

  @org_attr %{
    enabled: true,
    name: "Acme",
    properties: %{},
    api_key: "ABC123"
  }

  setup %{conn: conn} do
    {:ok, created_organization} =
      @org_attr
      |> Management.create_organization()

    {:ok,
     created_organization: created_organization,
     conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "post /api/auth" do
    test "with valid api key generate JWT", %{
      created_organization: created_organization,
      conn: conn
    } do
      conn = post(conn, ~p"/api/auth", %{"api_key" => created_organization.api_key})

      assert %{
               "id" => created_organization.id,
               "name" => created_organization.name
             } == json_response(conn, 201)["data"]

      token = get_resp_header(conn, "authorization") |> List.first()

      assert token |> String.split(".") |> length == 3
    end

    test "with invalid return error", %{conn: conn} do
      conn = post(conn, ~p"/api/auth", %{"api_key" => "invalid"})

      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
    end
  end
end
