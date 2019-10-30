defmodule SimpleOtpWeb.PageController do
  use SimpleOtpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render(conn, "index.html")
  end
end
