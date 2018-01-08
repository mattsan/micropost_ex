defmodule MicropostWeb.Utilities do
  use Phoenix.ConnTest
  import MicropostWeb.Router.Helpers

  @endpoint MicropostWeb.Endpoint
  @default_password "foobar"

  def visit(%{conn: conn, path: path} = context) do
    status_code = Map.get(context, :status, 200)
    response = conn
      |> get(path)
      |> html_response(status_code)
    [response: response]
  end

  def create_user(context) do
    password = get_password(context)

    attributes = %{
      name: String.replace(Faker.Name.name(), "'", ""),
      email: String.replace(Faker.Internet.email(), "'", ""),
      password: password,
      password_confirmation: password
    }

    {:ok, user} = %Micropost.User{}
      |> Micropost.User.changeset(attributes)
      |> Micropost.User.insert()

    users = Map.get(context, :users, [])

    [user: user, users: [user|users]]
  end

  def sign_in(%{conn: conn, user: user} = context) do
    posted_conn = post(conn, session_path(conn, :create), user: %{email: user.email, password: get_password(context)})
    [conn: posted_conn]
  end

  defp get_password(context) do
    Map.get(context, :password, @default_password)
  end
end
