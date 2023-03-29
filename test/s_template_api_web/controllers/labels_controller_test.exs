defmodule STemplateAPIWeb.LabelControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPIWeb.Auth.AuthHelper

  setup %{conn: conn} do
    organization = insert(:organization)
    insert(:template, organization: organization, labels: ["label1", "label2"])
    insert(:template, organization: organization, labels: ["label3", "label2"])

    insert(:template, labels: ["label4", "label5"], organization: insert(:organization))
    Cache.LabelsCache.rebuild()

    conn = conn |> AuthHelper.with_valid_authorization_header(organization.id)
    {:ok, conn: conn, organization: organization}
  end

  describe "index" do
    test "list all labels from organizations", %{conn: conn, organization: organization} do
      conn = get(conn, ~p"/api/organizations/#{organization.id}/labels")
      assert ["label1", "label2", "label3"] = json_response(conn, 200)["data"]

      organization = insert(:organization, parent_organization_id: organization.id)
      conn = build_conn() |> AuthHelper.with_valid_authorization_header(organization.id)
      conn = get(conn, ~p"/api/organizations/#{organization.id}/labels")
      assert [] = json_response(conn, 200)["data"]
    end

    test "render unauthorized without valid JWT", %{conn: conn} do
      organization = insert(:organization)
      conn = get(conn, ~p"/api/organizations/#{organization.id}/labels")
      assert %{"errors" => %{"detail" => "Unauthorized"}} == json_response(conn, 401)
    end
  end
end
