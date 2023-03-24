defmodule STemplateAPI.Liquid.Render do
  @moduledoc """
    Render a template by name with the params
  """
  alias STemplateAPI.Templates.Template

  @doc """
    Exec the parser and transform

    # Example

    iex> Render.call("some_template", %{ "user" => %{ "name" => "john"}})
    {:ok, "Hello john"
  }
  """
  @spec call(%Template{}, map) :: {:error, String.t()} | {:ok, String.t()}
  def call(nil, _), do: {:error, "Template not found"}
  def call(template, params), do: template |> render(params)

  defp render(template, params) do
    case Solid.parse(template.template) do
      {:ok, text} ->
        result =
          text
          |> Solid.render!(params)
          |> to_string

        {:ok, result}

      {:error, %Solid.TemplateError{message: msg}} ->
        {:error, msg}
    end
  end
end
