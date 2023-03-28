defmodule STemplateAPIWeb.OrganizationControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPIWeb.Auth.AuthHelper
  alias STemplateAPI.Management.Organization

  @create_attrs %{
    enabled: true,
    external_id: "some external_id",
    name: "some name",
    properties: %{},
    api_key: "abc123"
  }
  @update_attrs %{
    enabled: false,
    external_id: "some updated external_id",
    name: "some updated name",
    properties: %{}
  }
  @invalid_attrs %{api_key_hash: nil, enabled: nil, external_id: nil, name: nil, properties: nil}

  setup %{conn: conn} do
    organization = insert(:organization)
    conn = conn |> AuthHelper.with_valid_authorization_header(organization.id)
    {:ok, conn: conn, organization: organization}
  end

  describe "index" do
    test "lists all organizations", %{conn: conn, organization: organization} do
      # One that belong to the organization
      id = organization.id
      # Another inner one, that belong
      %{id: id2} = insert(:organization, parent_organization_id: organization.id)
      conn = conn |> AuthHelper.with_valid_authorization_header(organization.id)
      # Another that doesn't belong to the organization (should not be listed)
      insert(:organization)

      conn = get(conn, ~p"/api/organizations")
      assert [%{"id" => ^id} | [%{"id" => ^id2}]] = json_response(conn, 200)["data"]
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        build_conn()
        |> AuthHelper.with_valid_authorization_header(id)

      conn = conn |> get(~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "enabled" => true,
               "external_id" => "some external_id",
               "name" => "some name",
               "properties" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organization" do
    test "renders organization when data is valid", %{
      conn: conn,
      organization: %Organization{id: id} = organization
    } do
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "enabled" => false,
               "external_id" => "some updated external_id",
               "name" => "some updated name",
               "properties" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders error when organization is not allowed", %{
      conn: conn
    } do
      organization = insert(:organization)
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 404)
    end

    test "render error on delete an unauthorized organization", %{conn: conn} do
      organization = insert(:organization)
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
    end
  end
end
