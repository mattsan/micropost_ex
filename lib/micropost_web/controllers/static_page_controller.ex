defmodule MicropostWeb.StaticPageController do
  use MicropostWeb, :controller

  def home(conn, _) do
    render(conn, "home.html")
  end

  def help(conn, _) do
    render(conn, "help.html")
  end

  def about(conn, _) do
    render(conn, "about.html")
  end

  def contact(conn, _) do
    render(conn, "contact.html")
  end
end
