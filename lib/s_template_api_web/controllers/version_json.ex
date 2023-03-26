defmodule STemplateAPIWeb.VersionJSON do
  alias STemplateAPI.Templates.Version

  @doc """
  Renders a list of versions.
  """
  def index(%{versions: versions}) do
    %{data: for(version <- versions, do: simple_data(version))}
  end

  @doc """
  Renders a single version.
  """
  def show(%{version: version}) do
    %{data: data(version)}
  end

  defp simple_data(%Version{} = version) do
    %{
      id: version.id,
      inserted_at: version.inserted_at
    }
  end

  defp data(%Version{} = version) do
    %{
      id: version.id,
      content: version.content,
      inserted_at: version.inserted_at
    }
  end
end
