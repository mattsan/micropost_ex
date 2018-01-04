defmodule MicropostWeb.StaticPageController do
  use MicropostWeb, :controller

  def home(conn, _) do
    render(conn, "home.html", page_title: 'Home') # TODO page_title を view に移動する（他の action も同様）
  end

  def help(conn, _) do
    render(conn, "help.html", page_title: 'Help')
  end

  def about(conn, _) do
    render(conn, "about.html", page_title: 'About Us')
  end
end
