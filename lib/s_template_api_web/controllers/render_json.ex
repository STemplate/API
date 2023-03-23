defmodule STemplateAPIWeb.RenderJSON do
  @doc """
  Renders a single template.
  """
  def render(%{result: result}) do
    %{
      data: result
    }
  end
end
