defmodule STemplateAPI.Repo do
  use Ecto.Repo,
    otp_app: :s_template_api,
    adapter: Ecto.Adapters.Postgres
end
