defmodule SimpleOtpWeb.Router do
  use SimpleOtpWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug SimpleOtpWeb.Services.Pipeline
    plug SimpleOtpWeb.Services.CurrentUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleOtpWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/create-user", PageController, :new
    post "/sign-up", PageController, :sign_up
    post "/sign-in", PageController, :sign_in
    get "/sign-out", PageController, :sign_out
  end

  scope "/", SimpleOtpWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/dashboard", PageController, :dashboard
    post "/create-vault", PageController, :create_vault

    get "/vault/:id/shells", PageController, :shells
    post "/vault/:id/create-shell", PageController, :create_shell

    get "/shell/:id", PageController, :shell
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleOtpWeb do
  #   pipe_through :api
  # end
end
