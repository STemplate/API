defmodule STemplateAPIWeb.GuardianTest do
  use STemplateAPI.DataCase

  alias STemplateAPI.Management.Organization
  alias STemplateAPIWeb.Auth.Guardian

  @org_attr %{
    enabled: true,
    name: "Acme",
    properties: %{},
    api_key: "ABC123"
  }

  setup do
    {:ok, created_organization} =
      %Organization{}
      |> Organization.changeset(@org_attr)
      |> Repo.insert()

    {:ok, created_organization: created_organization}
  end

  describe "authenticate/1" do
    test "with valid key generate JWT", %{created_organization: created_organization} do
      {:ok, organization, token} = Guardian.authenticate(created_organization.api_key)
      assert organization.id == created_organization.id
      assert token |> String.split(".") |> length == 3
    end

    test "with invalid return error" do
      assert {:error, :unauthorized} = Guardian.authenticate("invalid")
    end
  end

  describe "subject_for_token/2" do
    test "with valid id return id", %{created_organization: created_organization} do
      assert {:ok, to_string(created_organization.id)} ==
               Guardian.subject_for_token(created_organization, %{})
    end

    test "with invalid return error" do
      assert {:error, :no_id_provided} = Guardian.subject_for_token(%{}, %{})
    end
  end

  describe "resource_from_claims/1" do
    test "with valid sub return organization", %{created_organization: created_organization} do
      assert {:ok, %{created_organization | api_key: nil}} ==
               Guardian.resource_from_claims(%{"sub" => to_string(created_organization.id)})
    end

    test "with invalid return error" do
      assert {:error, :no_sub_provided} == Guardian.resource_from_claims(%{})
    end
  end
end
