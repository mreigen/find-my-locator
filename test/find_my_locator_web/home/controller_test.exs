defmodule FindMyLocatorWeb.Home.ControllerTest do
  use FindMyLocatorWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hello, world!"
  end
end
