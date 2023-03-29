defmodule STemplateAPIWeb.TemplateControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPIWeb.Auth.AuthHelper
  alias STemplateAPI.Templates.Template

  @create_attrs %{
    enabled: true,
    labels: ["user", "signup"],
    name: "company1.user.signup",
    template:
      "Welcome to the jungle {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!",
    type: "application/txt"
  }
  @update_attrs %{
    enabled: true,
    labels: ["user", "signup"],
    name: "company1.user.signup",
    template:
      "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!",
    type: "application/txt"
  }
  @invalid_attrs %{enabled: nil, labels: nil, name: nil, template: nil, type: nil}

  setup %{conn: conn} do
    organization = insert(:organization)
    conn = conn |> AuthHelper.with_valid_authorization_header(organization.id)
    {:ok, conn: conn, organization: organization}
  end

  describe "index" do
    test "lists all templates", %{conn: conn, organization: organization} do
      # One that belong to the organization
      %Template{id: id} = insert(:template, organization: organization, labels: ["bar", "foo"])

      # Another template that belongs to an inner organization
      sub_organization = insert(:organization, parent_organization_id: organization.id)
      %Template{id: id2} = insert(:template, organization: sub_organization)

      # Another that doesn't belong to the organization (should not be listed)
      insert(:template, organization: insert(:organization))

      # with labels
      conn = conn |> AuthHelper.with_valid_authorization_header(organization.id)
      conn = get(conn, ~p"/api/templates?labels=bar,foo")
      response = json_response(conn, 200)["data"]
      assert response |> length() == 1
      assert [%{"id" => ^id}] = response

      # ignoring order
      conn = build_conn() |> AuthHelper.with_valid_authorization_header(organization.id)
      conn = get(conn, ~p"/api/templates?labels=foo,bar")
      response = json_response(conn, 200)["data"]
      assert response |> length() == 1
      assert [%{"id" => ^id}] = response

      # without labels
      conn = build_conn() |> AuthHelper.with_valid_authorization_header(organization.id)
      conn = get(conn, ~p"/api/templates")
      response = json_response(conn, 200)["data"]
      assert response |> length() == 2
      assert [%{"id" => ^id} | [%{"id" => ^id2}]] = response
    end
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn, organization: organization} do
      conn =
        post(conn, ~p"/api/templates",
          template: @create_attrs |> Map.put(:organization_id, organization.id)
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/templates/#{id}")

      assert %{
               "id" => id,
               "enabled" => @create_attrs.enabled,
               "labels" => @create_attrs.labels,
               "name" => @create_attrs.name,
               "template" => @create_attrs.template,
               "type" => @create_attrs.type
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/templates", template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update template" do
    setup [:create_template]

    test "renders template when data is valid", %{
      conn: conn,
      template: %Template{id: id} = template
    } do
      conn = put(conn, ~p"/api/templates/#{template}", template: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/templates/#{id}")

      assert %{
               "template" =>
                 "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!"
             } = json_response(conn, 200)["data"]
    end

    test "renders error when template doesn't belong to organization", %{
      conn: conn
    } do
      another_org = insert(:organization)
      template = insert(:template, organization: another_org)

      conn = put(conn, ~p"/api/templates/#{template}", template: @update_attrs)

      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
    end

    test "renders error when template try to change to a wrong organization", %{
      conn: conn,
      template: template
    } do
      another_org = insert(:organization)

      conn =
        put(
          conn,
          ~p"/api/templates/#{template}",
          template: @update_attrs |> Map.put(:organization_id, another_org.id)
        )

      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
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

      conn = get(conn, ~p"/api/templates/#{template}")
      assert response(conn, 404)
    end

    test "render error when chosen template doesn't belong to organization", %{conn: conn} do
      template = insert(:template, organization: insert(:organization))
      conn = delete(conn, ~p"/api/templates/#{template}")
      assert response(conn, 401)
    end
  end

  defp create_template(%{organization: organization}) do
    %{template: insert(:template, organization: organization)}
  end
end
