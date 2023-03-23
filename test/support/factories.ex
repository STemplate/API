defmodule STemplateAPI.Test.Factories do
  @moduledoc """
  Define factories for use in tests.
  """

  use ExMachina.Ecto, repo: STemplateAPI.Repo

  def template_factory do
    %STemplateAPI.Templates.Template{
      enabled: true,
      labels: ["hardcoded", Faker.Lorem.word()],
      name: Faker.Food.dish() |> sequence,
      template: Faker.Lorem.sentence(),
      type: "application/txt"
    }
  end
end
