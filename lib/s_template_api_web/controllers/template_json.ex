defmodule STemplateAPIWeb.TemplateJSON do
  alias STemplateAPI.Templates.Template

  @doc """
  Renders a list of templates.
  """
  def index(%{templates: templates}) do
    %{data: for(template <- templates, do: data(template))}
  end

  @doc """
  Renders a single template.
  """
  def show(%{template: template}) do
    %{data: data(template)}
  end

  defp data(%Template{} = template) do
    %{
      id: template.id,
      name: template.name,
      template: template.template,
      enabled: template.enabled,
      labels: template.labels,
      type: template.type
    }
  end
end
