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
    plug SimpleOtpWeb.Plugs.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleOtpWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", SimpleOtpWeb do
    pipe_through [:browser, :auth]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleOtpWeb do
  #   pipe_through :api
  # end
end
