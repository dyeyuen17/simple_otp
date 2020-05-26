defmodule SimpleOtpWeb.Services.ErrorHandler do
  import Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    redirect(conn, to: "/")
  end
end
