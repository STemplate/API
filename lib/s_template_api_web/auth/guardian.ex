defmodule STemplateAPIWeb.Auth.Guardian do
  @moduledoc """
  Guardian configuration for the API.
  Authentication `token` based, with JWT tokens.
  """

  use Guardian, otp_app: :s_template_api

  alias STemplateAPI.Management
  alias STemplateAPI.Templates.Template
  alias STemplateAPI.Management.Organization

  @doc """
  Subject of the Payload in the JWT.

  From the organization, we get the id and all the descendant ones.

  ## Examples
    iex> Management.subject_for_token(%{id: 1}, %{})
    {:ok, [1, 2, 3]}
  """
  @spec subject_for_token(any, any) :: {:error, :no_organization_provided} | {:ok, binary}
  def subject_for_token(%Organization{} = organization, _claims) do
    {:ok, descendants} = organization |> Management.get_descendant_organization_ids()

    {:ok, descendants}
  end

  def subject_for_token(_, _), do: {:error, :no_organization_provided}

  @doc """
  In JWT this be found in the `sub` field.
  Get the list of organization ids from the claims and return the organizations.
  """
  @spec resource_from_claims(any) :: {:error, :no_sub_provided | :not_found} | {:ok, any}
  def resource_from_claims(%{"sub" => sub}) do
    [ids: sub] |> Management.list_organizations()
  end

  def resource_from_claims(_), do: {:error, :no_sub_provided}

  @doc """
  Authenticates the organization with the given credentials.
  """
  @spec authenticate(binary) :: {:error, :unauthorized} | {:ok, struct(), binary}
  def authenticate(api_key) do
    with {:ok, organization} <- Management.get_organization_by_api_key(api_key),
         {:ok, token, _claims} <- encode_and_sign(organization) do
      {:ok, organization, token}
    else
      _ -> {:error, :unauthorized}
    end
  end

  def allowed?(conn, to) do
    conn
    |> Guardian.Plug.current_claims()
    |> do_check_access(to)
  end

  defp do_check_access(%{"sub" => allowed_organization_ids}, %Template{organization_id: org_id}),
    do: access_result(allowed_organization_ids, org_id)

  defp do_check_access(%{"sub" => allowed_organization_ids}, %Organization{id: org_id}),
    do: access_result(allowed_organization_ids, org_id)

  defp access_result(allowed_organization_ids, org_id) do
    if allowed_organization_ids |> Enum.member?(org_id),
      do: {:ok, org_id},
      else: {:error, :unauthorized}
  end
end
