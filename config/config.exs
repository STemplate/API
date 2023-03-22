# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :s_template_api,
  namespace: STemplateAPI,
  ecto_repos: [STemplateAPI.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :s_template_api, STemplateAPIWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: STemplateAPIWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: STemplateAPI.PubSub,
  live_view: [signing_salt: "5LCw3Rsq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
