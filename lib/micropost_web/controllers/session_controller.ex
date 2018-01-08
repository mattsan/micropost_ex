defmodule MicropostWeb.SessionController do
  use MicropostWeb, :controller

  alias Micropost.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user = User.get_by(email: user_params["email"])

    if user && User.authenticated?(user, user_params["password"]) do
      path = get_session(conn, :return_path) || user_path(conn, :show, user)

      conn
      |> delete_session(:return_path)
      |> put_session(:remember_token, user.remember_token)
      |> put_flash(:success, "Welcome back!")
      |> redirect(to: path)
    else
      changeset = User.changeset(%User{}, user_params)
      conn
      |> put_flash(:error, "Invalid email/password combination")
      |> redirect(to: session_path(conn, :new), changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:remember_token)
    |> redirect(to: static_page_path(conn, :home))
  end
end
