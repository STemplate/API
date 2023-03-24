defmodule STemplateAPIWeb.VersionJSON do
  alias STemplateAPI.Templates.Version

  @doc """
  Renders a list of versions.
  """
  def index(%{versions: versions}) do
    %{data: for(version <- versions, do: data(version))}
  end

  @doc """
  Renders a single version.
  """
  def show(%{version: version}) do
    %{data: data(version)}
  end

  defp data(%Version{} = version) do
    %{
      id: version.id,
      content: version.content
    }
  end
end
