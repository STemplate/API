defmodule STemplateAPI.ManagementTest do
  use STemplateAPI.DataCase

  alias STemplateAPI.Management

  describe "organizations" do
    alias STemplateAPI.Management.Organization

    import STemplateAPI.Test.Factories

    @invalid_attrs %{
      api_key_hash: nil,
      enabled: nil,
      external_id: nil,
      name: nil,
      properties: nil
    }

    test "list_organizations/0 returns all organizations" do
      organization = insert(:organization)
      assert Management.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = insert(:organization)
      assert Management.get_organization(organization.id) == {:ok, organization}
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{
        api_key: "asd",
        enabled: true,
        external_id: "some external_id",
        name: "some name",
        properties: %{}
      }

      assert {:ok, %Organization{} = organization} = Management.create_organization(valid_attrs)
      assert organization.api_key_hash == Encryption.Hashing.hash(valid_attrs.api_key)
      assert organization.enabled == true
      assert organization.external_id == "some external_id"
      assert organization.name == "some name"
      assert organization.properties == %{}
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Management.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = insert(:organization)

      update_attrs = %{
        api_key: "some updated api_key_hash",
        enabled: false,
        external_id: "some updated external_id",
        name: "some updated name",
        properties: %{}
      }

      assert {:ok, %Organization{} = organization} =
               Management.update_organization(organization, update_attrs)

      assert organization.api_key_hash == Encryption.Hashing.hash(update_attrs.api_key)
      assert organization.enabled == false
      assert organization.external_id == "some updated external_id"
      assert organization.name == "some updated name"
      assert organization.properties == %{}
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = insert(:organization)

      assert {:error, %Ecto.Changeset{}} =
               Management.update_organization(organization, @invalid_attrs)

      assert {:ok, organization} == Management.get_organization(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = insert(:organization)
      assert {:ok, %Organization{}} = Management.delete_organization(organization)
      assert {:error, :not_found} = Management.get_organization(organization.id)
    end

    test "change_organization/1 returns a organization changeset" do
      organization = insert(:organization)
      assert %Ecto.Changeset{} = Management.change_organization(organization)
    end
  end
end
