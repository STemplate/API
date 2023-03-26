defmodule STemplateAPIWeb.OrganizationControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPI.Management.Organization

  @create_attrs %{
    enabled: true,
    external_id: "some external_id",
    name: "some name",
    properties: %{}
  }
  @update_attrs %{
    enabled: false,
    external_id: "some updated external_id",
    name: "some updated name",
    properties: %{}
  }
  @invalid_attrs %{api_key_hash: nil, enabled: nil, external_id: nil, name: nil, properties: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get(conn, ~p"/api/organizations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")

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
    setup [:create_organization]

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

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 404)
    end
  end

  defp create_organization(_) do
    organization = insert(:organization)
    %{organization: organization}
  end
end
