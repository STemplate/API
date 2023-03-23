defmodule Liquid.RenderTest do
  use STemplateAPIWeb.ConnCase

  import STemplateAPI.Test.Factories

  alias STemplateAPI.Liquid.Render

  describe "Liquid.Render.call/2" do
    test "with nil template returns error" do
      assert Render.call(nil, %{}) == {:error, "Template not found"}
    end

    test "with template and right params returns ok" do
      template = insert(:template, template: ~s(This is a template from '{{ user.name }}'
        with mail: '{{ user.email }}'
        and company '{{ company.name }}' with address '{{ company.address }}'))

      assert Render.call(template, %{
               "user" => %{
                 "name" => "John",
                 "email" => "john.do@gmail.com"
               },
               "company" => %{
                 "name" => "Acme",
                 "address" => "123 Main St"
               }
             }) == {:ok, ~s(This is a template from 'John'
        with mail: 'john.do@gmail.com'
        and company 'Acme' with address '123 Main St')}
    end

    test "with template and missing params returns ok" do
      template = insert(:template, template: ~s(This is a template from '{{ user.name }}'
        with mail: '{{ user.email }}'
        and company '{{ company.name }}' with address '{{ company.address }}'))

      assert Render.call(template, %{
               "user" => %{
                 "name" => "John",
                 "email" => "john.do@gmail.com"
               }
             }) == {:ok, ~s(This is a template from 'John'
        with mail: 'john.do@gmail.com'
        and company '' with address '')}
    end

    test "with template including list returns ok" do
      template = insert(:template, template: ~s(
        This is a template from '{{ user.name }}'
        {% for product in collection.products %}
          '{{ product.title }}'
        {% else %}
          The collection is empty.
        {% endfor %}
      ))

      {:ok, r} =
        Render.call(template, %{
          "user" => %{
            "name" => "John"
          },
          "collection" => %{
            "products" => [
              %{"title" => "Product 1"},
              %{"title" => "Product 2"}
            ]
          }
        })

      assert r |> String.trim() ==
               "This is a template from 'John'\n        \n          'Product 1'\n        \n          'Product 2'"
    end
  end
end
