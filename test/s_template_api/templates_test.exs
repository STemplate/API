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

    test "get_template/1 returns the template with given id" do
      template = insert(:template)
      assert Templates.get_template(template.id) == {:ok, template}
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
      assert {:ok, template} == Templates.get_template(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = insert(:template)
      assert {:ok, %Template{}} = Templates.delete_template(template)
      assert {:error, :not_found} = Templates.get_template(template.id)
    end

    test "change_template/1 returns a template changeset" do
      template = insert(:template)
      assert %Ecto.Changeset{} = Templates.change_template(template)
    end
  end

  describe "versions" do
    alias STemplateAPI.Templates.{Template, Version}
    alias STemplateAPI.Repo

    import STemplateAPI.Test.Factories

    test "get_version/1 returns the version with given id" do
      version = insert(:version)

      {:ok, %{id: id, content: content}} = Templates.get_version(version.id)
      assert id == version.id
      assert content == version.content
    end

    test "update_template/2 with valid data create a version with the previous" do
      template = insert(:template, template: "some template")
      update_attrs = %{template: "some updated template"}
      assert {:ok, %Template{} = template} = Templates.update_template(template, update_attrs)
      assert template.template == "some updated template"

      template = template |> Repo.preload(:versions)

      [
        %Version{template_id: template_id, content: content}
      ] = template.versions

      assert template_id == template.id
      assert content == "some template"

      assert template.versions |> length() == 1

      # update again (only name) will not create new version
      update_attrs = %{name: "some updated name"}
      assert {:ok, %Template{} = template} = Templates.update_template(template, update_attrs)
      assert template.name == "some updated name"

      template = template |> Repo.preload(:versions)
      assert template.versions |> length() == 1
    end

    test "update_template/2 with invalid data not create a version" do
      template = insert(:template)

      assert {:error, %Ecto.Changeset{}} = Templates.update_template(template, %{template: nil})

      {:ok, template} = Templates.get_template(template.id)
      template = template |> Repo.preload(:versions)
      assert [] == template.versions
    end

    test "delete_version/1 deletes the version" do
      version = insert(:version)
      assert {:ok, %Version{}} = Templates.delete_version(version)
      assert {:error, :not_found} = Templates.get_version(version.id)
    end
  end
end
