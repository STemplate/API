defmodule STemplateAPIWeb.TemplateControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.TemplatesFixtures

  alias STemplateAPI.Templates.Template

  @create_attrs %{
    enabled: true,
    labels: ["option1", "option2"],
    name: "some name",
    template: "some template",
    type: "some type"
  }
  @update_attrs %{
    enabled: false,
    labels: ["option1"],
    name: "some updated name",
    template: "some updated template",
    type: "some updated type"
  }
  @invalid_attrs %{enabled: nil, labels: nil, name: nil, template: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all templates", %{conn: conn} do
      conn = get(conn, ~p"/api/templates")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/templates", template: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/templates/#{id}")

      assert %{
               "id" => ^id,
               "enabled" => true,
               "labels" => ["option1", "option2"],
               "name" => "some name",
               "template" => "some template",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/templates", template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update template" do
    setup [:create_template]

    test "renders template when data is valid", %{conn: conn, template: %Template{id: id} = template} do
      conn = put(conn, ~p"/api/templates/#{template}", template: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/templates/#{id}")

      assert %{
               "id" => ^id,
               "enabled" => false,
               "labels" => ["option1"],
               "name" => "some updated name",
               "template" => "some updated template",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, template: template} do
      conn = put(conn, ~p"/api/templates/#{template}", template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete template" do
    setup [:create_template]

    test "deletes chosen template", %{conn: conn, template: template} do
      conn = delete(conn, ~p"/api/templates/#{template}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/templates/#{template}")
      end
    end
  end

  defp create_template(_) do
    template = template_fixture()
    %{template: template}
  end
end
