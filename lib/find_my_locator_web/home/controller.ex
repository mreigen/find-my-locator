defmodule FindMyLocatorWeb.Home.Controller do
  use Phoenix.Controller

  plug(:put_view, FindMyLocatorWeb.Home.HTML)

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _) do
    render(conn, "index.html", message: "Hello, world!")
  end
end
