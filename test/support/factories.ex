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
      name: Faker.Superhero.En.name() |> sequence,
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
      name: Faker.Company.En.name() |> sequence,
      properties: %{
        "bar" => %{
          "foo" => Faker.Lorem.word()
        }
      },
      api_key: Faker.Finance.Stock.ticker(),
      api_key_hash: Faker.Finance.Stock.ticker() |> sequence |> Encryption.Hashing.hash(),
      parent_organization_id: nil
    }
  end
end
