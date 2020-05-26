defmodule SimpleOtpWeb.Services.CurrentUser do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn

      user ->
        conn
        |> assign(:current_user, user)
        |> put_private(:current_user, user)
    end
  end
end
