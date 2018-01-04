defmodule MicropostWeb.UserController do
  use MicropostWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end
end
