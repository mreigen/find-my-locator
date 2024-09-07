defmodule FindMyLocatorWeb.Home.HTML do
  use Phoenix.Component

  embed_templates("templates/*")

  def render("index.html", assigns), do: index(assigns)

  attr(:text, :string, required: true)
  def message(assigns)

  attr(:url, :string, default: "https://github.com/mirego/find-my-locator")
  def header(assigns)
end
