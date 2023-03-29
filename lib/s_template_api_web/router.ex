defmodule STemplateAPIWeb.Router do
  use STemplateAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug STemplateAPIWeb.Auth.Pipeline
  end

  # Unauthenticated routes
  scope "/api", STemplateAPIWeb do
    pipe_through [:api]

    resources "/auth", AuthController, only: [:create] do
      resources "/refresh", AuthController, only: [:create]
    end

    resources "/organizations", OrganizationController, only: [:create]
  end

  # Authenticated routes
  scope "/api", STemplateAPIWeb do
    pipe_through [:api, :auth]

    resources "/organizations", OrganizationController,
      only: [:index, :create, :show, :update, :delete] do
      resources "/labels", LabelController, only: [:index]
    end

    resources "/templates", TemplateController, only: [:index, :create, :show, :update, :delete] do
      resources "/versions", VersionController, only: [:index]
    end

    resources "/versions", VersionController, only: [:show, :delete]

    resources "/render", RenderController, only: [:create]
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
