defmodule STemplateAPIWeb.AuthJSON do
  @doc """
  Renders a simple organization.
  """
  def show(%{organization: organization}) do
    %{
      data: %{
        id: organization.id,
        name: organization.name
      }
    }
  end
end
