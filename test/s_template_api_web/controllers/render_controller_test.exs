defmodule STemplateAPIWeb.RenderControllerTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPIWeb.Auth.AuthHelper
  alias STemplateAPI.Templates.Template

  setup %{conn: conn} do
    conn =
      conn
      |> AuthHelper.with_valid_authorization_header()

    {:ok, conn: conn}
  end

  describe "render" do
    test "apply a template with parameters", %{conn: conn} do
      %Template{name: name} =
        insert(:template,
          template: "Hello '{{ user.name }}' from: '{{ company.name }}'"
        )

      conn =
        post(conn, ~p"/api/render", %{
          name: name,
          params: %{
            "user" => %{
              "name" => "John"
            },
            "company" => %{
              "name" => "Acme"
            }
          }
        })

      response = json_response(conn, 200)["data"]
      assert response == "Hello 'John' from: 'Acme'"
    end
  end
end
