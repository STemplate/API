defmodule STemplateAPI.Test.Factories do
  @moduledoc """
  Define factories for use in tests.
  """

  use ExMachina.Ecto, repo: STemplateAPI.Repo

  alias STemplateAPI.Templates.{Template, Version}

  def template_factory do
    %Template{
      enabled: true,
      labels: ["hardcoded", Faker.Lorem.word()],
      name: Faker.Food.dish() |> sequence,
      template: Faker.Lorem.sentence(),
      type: "application/txt"
    }
  end

  def version_factory do
    %Version{
      content: Faker.Lorem.sentence(),
      template: build(:template)
    }
  end
end
