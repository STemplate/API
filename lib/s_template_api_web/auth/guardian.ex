defmodule STemplateAPIWeb.Auth.Guardian do
  @moduledoc """
  Guardian configuration for the API.
  Authentication `token` based, with JWT tokens.
  """

  use Guardian, otp_app: :s_template_api
  alias STemplateAPI.Management

  @doc """
  Subject of the Payload in the JWT.

  From the organization, we get the id and all the descendant ones.

  ## Examples
    iex> Management.subject_for_token(%{id: 1}, %{})
    {:ok, [1, 2, 3]}
  """
  @spec subject_for_token(any, any) :: {:error, :no_organization_provided} | {:ok, binary}
  def subject_for_token(nil, _), do: {:error, :no_organization_provided}

  def subject_for_token(organization, _claims) do
    {:ok, descendants} = organization |> Management.get_descendant_organization_ids()

    {:ok, descendants}
  end

  @doc """
  In JWT this be found in the `sub` field.
  Get the list of organization ids from the claims and return the organizations.
  """
  @spec resource_from_claims(any) :: {:error, :no_sub_provided | :not_found} | {:ok, any}
  # def resource_from_claims(%{"sub" => sub}), do: sub |> Management.get_organization()
  def resource_from_claims(%{"sub" => sub}) do
    sub |> Management.list_organizations()
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
end
