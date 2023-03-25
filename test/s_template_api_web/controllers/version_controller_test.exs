defmodule STemplateAPIWeb.VersionControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPI.Templates.{Template, Version}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all versions", %{conn: conn} do
      %Template{id: template_id} = template = insert(:template)

      conn = get(conn, ~p"/api/templates/#{template_id}/versions")
      assert json_response(conn, 200)["data"] == []

      insert(:version, template: template, content: "bar")
      insert(:version, template: template, content: "foo")

      conn = get(conn, ~p"/api/templates/#{template_id}/versions")
      [%{"content" => a} | [%{"content" => b}]] = json_response(conn, 200)["data"]

      assert a == "bar"
      assert b == "foo"
    end

    test "invalid template", %{conn: conn} do
      conn = get(conn, ~p"/api/templates/7d539566-2b88-47cb-8dad-86ecf55d43fd/versions")
      assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
    end
  end

  describe "show" do
    setup [:create_version]

    test "renders version when data is valid", %{conn: conn} do
      %Version{id: id} = insert(:version, content: "bar")

      conn = get(conn, ~p"/api/versions/#{id}")

      assert %{
               "id" => ^id,
               "content" => "bar"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = get(conn, ~p"/api/versions/59b78e3a-351b-44de-bfb3-4220fd145f5c")
      assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "deletes chosen version", %{conn: conn, version: version} do
      conn = delete(conn, ~p"/api/versions/#{version.id}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/versions/#{version}")
      assert response(conn, 404)
    end
  end

  defp create_version(_) do
    %{version: insert(:version)}
  end
end
