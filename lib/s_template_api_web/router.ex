defmodule STemplateAPIWeb.Router do
  use STemplateAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", STemplateAPIWeb do
    pipe_through :api

    resources "/templates", TemplateController, only: [:index, :create, :show, :update, :delete]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:s_template_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: STemplateAPIWeb.Telemetry
    end
  end
end
