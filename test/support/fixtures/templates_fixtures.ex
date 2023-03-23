defmodule STemplateAPI.TemplatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `STemplateAPI.Templates` context.
  """

  @doc """
  Generate a template.
  """
  def template_fixture(attrs \\ %{}) do
    {:ok, template} =
      attrs
      |> Enum.into(%{
        enabled: true,
        labels: ["option1", "option2"],
        name: "some name",
        template: "some template",
        type: "some type"
      })
      |> STemplateAPI.Templates.create_template()

    template
  end
end
