defmodule MicropostWeb.PageController do
  use MicropostWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", page_title: nil
  end
end
