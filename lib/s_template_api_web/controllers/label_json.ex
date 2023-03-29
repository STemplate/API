defmodule STemplateAPIWeb.LabelJSON do
  @doc """
  Renders a list of labels.
  """
  def index(%{labels: labels}) do
    %{data: labels}
  end
end
