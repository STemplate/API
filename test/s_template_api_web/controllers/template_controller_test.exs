defmodule STemplateAPIWeb.TemplateControllerTest do
  use STemplateAPIWeb.ConnCase

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  import STemplateAPI.Test.Factories
=======
  import STemplateAPI.TemplatesFixtures
>>>>>>> 4efc0aa (Generated files)
=======
  # import STemplateAPI.TemplatesFixtures
=======
>>>>>>> b6ee137 (Removed fixture)
  import STemplateAPI.Test.Factories
>>>>>>> bcf22ab (Test factory for templates and update controller test)

  alias STemplateAPI.Templates.Template

  @create_attrs %{
    enabled: true,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bcf22ab (Test factory for templates and update controller test)
    labels: ["user", "signup"],
    name: "company1.user.signup",
    template:
      "Welcome to the jungle {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!",
    type: "application/txt"
<<<<<<< HEAD
  }
  @update_attrs %{
    enabled: true,
    labels: ["user", "signup"],
    name: "company1.user.signup",
    template:
      "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!",
    type: "application/txt"
=======
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
>>>>>>> 4efc0aa (Generated files)
=======
  }
  @update_attrs %{
    enabled: true,
    labels: ["user", "signup"],
    name: "company1.user.signup",
    template: "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!",
    type: "application/txt"
>>>>>>> bcf22ab (Test factory for templates and update controller test)
  }
  @invalid_attrs %{enabled: nil, labels: nil, name: nil, template: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all templates", %{conn: conn} do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bcf22ab (Test factory for templates and update controller test)

=======
>>>>>>> a6c9ffc (Added render endpoint)
      %Template{id: id} = insert(:template)
      insert(:template)

<<<<<<< HEAD
      conn = get(conn, ~p"/api/templates")
      response = json_response(conn, 200)["data"]

      assert response |> length() == 2
      assert [%{"id" => ^id} | _tail] = response
=======
      conn = get(conn, ~p"/api/templates")
      assert json_response(conn, 200)["data"] == []
>>>>>>> 4efc0aa (Generated files)
=======
      conn = get(conn, ~p"/api/templates")
      response = json_response(conn, 200)["data"]

      assert response |> length() == 2
      assert [%{"id" => ^id} | _tail] = response
>>>>>>> bcf22ab (Test factory for templates and update controller test)
    end
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/templates", template: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/templates/#{id}")

      assert %{
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bcf22ab (Test factory for templates and update controller test)
        "id" => id,
        "enabled" => @create_attrs.enabled,
        "labels" => @create_attrs.labels,
        "name" => @create_attrs.name,
        "template" => @create_attrs.template,
        "type" => @create_attrs.type
        } == json_response(conn, 200)["data"]
      end
<<<<<<< HEAD

      test "renders errors when data is invalid", %{conn: conn} do
        conn = post(conn, ~p"/api/templates", template: @invalid_attrs)
        assert json_response(conn, 422)["errors"] != %{}
      end
    end

=======
               "id" => ^id,
               "enabled" => true,
               "labels" => ["option1", "option2"],
               "name" => "some name",
               "template" => "some template",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end
=======
>>>>>>> bcf22ab (Test factory for templates and update controller test)

      test "renders errors when data is invalid", %{conn: conn} do
        conn = post(conn, ~p"/api/templates", template: @invalid_attrs)
        assert json_response(conn, 422)["errors"] != %{}
      end
    end

>>>>>>> 4efc0aa (Generated files)
=======
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

>>>>>>> a6c9ffc (Added render endpoint)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
               "template" => "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!"
=======
               "id" => ^id,
               "enabled" => false,
               "labels" => ["option1"],
               "name" => "some updated name",
               "template" => "some updated template",
               "type" => "some updated type"
>>>>>>> 4efc0aa (Generated files)
=======
               "template" => "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!"
>>>>>>> bcf22ab (Test factory for templates and update controller test)
=======
               "template" =>
                 "Welcome to the COMPANY {{user.name}}. You are now a member of {{company.name}}. Enjoy your stay with us!"
>>>>>>> a6c9ffc (Added render endpoint)
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
<<<<<<< HEAD
<<<<<<< HEAD
    template = insert(:template)
=======
    template = template_fixture()
>>>>>>> 4efc0aa (Generated files)
=======
    template = insert(:template)
>>>>>>> bcf22ab (Test factory for templates and update controller test)
    %{template: template}
  end
end
