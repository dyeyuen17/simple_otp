defmodule SimpleOtpWeb.PageControllerTest do
  use SimpleOtpWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert true
  end
end
