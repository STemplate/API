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
      type: "application/txt",
      organization: build(:organization)
    }
  end

  def version_factory do
    %Version{
      content: Faker.Lorem.sentence(),
      template: build(:template)
    }
  end

  def organization_factory do
    %STemplateAPI.Management.Organization{
      enabled: true,
      external_id: Faker.Lorem.word(),
      name: Faker.Lorem.word(),
      properties: %{
        "bar" => %{
          "foo" => Faker.Lorem.word()
        }
      },
      api_key: Faker.Lorem.word(),
      api_key_hash: Faker.Lorem.word() |> Encryption.Hashing.hash()
    }
  end
end
