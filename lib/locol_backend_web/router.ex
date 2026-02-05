defmodule LocolBackendWeb.Router do
  use LocolBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LocolBackendWeb do
    pipe_through [:api, LocolBackendWeb.Plugs.Auth]

    resources "/artists", ArtistController, except: [:new, :edit]
    resources "/items", ItemController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:locol_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LocolBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
