defmodule STemplateAPI.TemplatesTest do
  use STemplateAPI.DataCase

  alias STemplateAPI.Templates

  describe "templates" do
    alias STemplateAPI.Templates.Template

    import STemplateAPI.Test.Factories

    @invalid_attrs %{enabled: nil, labels: nil, name: nil, template: nil, type: nil}

    test "list_templates/0 returns all templates" do
      template = insert(:template)
      assert Templates.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = insert(:template)
      assert Templates.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      valid_attrs = %{
        enabled: true,
        labels: ["option1", "option2"],
        name: "some name",
        template: "some template",
        type: "some type"
      }

      assert {:ok, %Template{} = template} = Templates.create_template(valid_attrs)
      assert template.enabled == true
      assert template.labels == ["option1", "option2"]
      assert template.name == "some name"
      assert template.template == "some template"
      assert template.type == "some type"
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Templates.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = insert(:template)

      update_attrs = %{
        enabled: false,
        labels: ["option1"],
        name: "some updated name",
        template: "some updated template",
        type: "some updated type"
      }

      assert {:ok, %Template{} = template} = Templates.update_template(template, update_attrs)
      assert template.enabled == false
      assert template.labels == ["option1"]
      assert template.name == "some updated name"
      assert template.template == "some updated template"
      assert template.type == "some updated type"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = insert(:template)
      assert {:error, %Ecto.Changeset{}} = Templates.update_template(template, @invalid_attrs)
      assert template == Templates.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = insert(:template)
      assert {:ok, %Template{}} = Templates.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Templates.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = insert(:template)
      assert %Ecto.Changeset{} = Templates.change_template(template)
    end
  end
end
