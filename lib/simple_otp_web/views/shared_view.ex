defmodule SimpleOtpWeb.SharedView do
  use SimpleOtpWeb, :view

  def active_link(conn, uri) do
    if uri in conn.path_info, do: "active", else: ""
  end

  def logo(conn) do
    Routes.static_path(conn, "/images/logo.svg")
  end
end
