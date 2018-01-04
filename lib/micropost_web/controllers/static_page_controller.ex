defmodule MicropostWeb.StaticPageController do
  use MicropostWeb, :controller

  def home(conn, _) do
    render(conn, "home.html", page_title: 'Home')
  end

  def help(conn, _) do
    render(conn, "help.html", page_title: 'Help')
  end

  def about(conn, _) do
    render(conn, "about.html", page_title: 'About Us')
  end
end
