defmodule FindMyLocatorWeb.PingTest do
  use FindMyLocatorWeb.ConnCase

  test "GET /ping", %{conn: conn} do
    conn = get(conn, "/ping")

    assert response(conn, 200)
  end
end
