defmodule MicropostWeb.UserController do
  use MicropostWeb, :controller

  alias Micropost.User

  def show(conn, %{"id" => id}) do
    user = User.get!(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case User.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Welcome to the Sample App!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, error_message(changeset))
        |> render("new.html", changeset: changeset)
    end
  end

  defp error_message(%{errors: errors} = _changeset) do
    count = Enum.count(errors)
    case count do
      0 -> ""
      1 -> "An error has occurred"
      _ -> "#{count} errors have occurred"
    end
  end
end
