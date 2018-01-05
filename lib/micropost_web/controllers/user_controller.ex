defmodule MicropostWeb.UserController do
  use MicropostWeb, :controller

  alias Micropost.{Repo, User}

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _) do
    render(conn, "new.html")
  end
end
