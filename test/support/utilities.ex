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

  def new_user(context) do
    user = new_changeset(context) |> Ecto.Changeset.apply_changes()
    [user: user]
  end

  def create_user(context) do
    {:ok, user} = new_changeset(context) |> Micropost.User.insert()

    users = Map.get(context, :users, [])

    [user: user, users: [user|users]]
  end

  def sign_in(%{conn: conn, user: user} = context) do
    posted_conn = post(conn, session_path(conn, :create), user: %{email: user.email, password: get_password(context)})
    [conn: posted_conn]
  end

  def default_password, do: @default_password

  defp get_password(context) do
    Map.get(context, :password, @default_password)
  end

  defp new_changeset(context) do
    user_params = Map.get(context, :user_params, %{})

    name = Map.get(user_params, :name, String.replace(Faker.Name.name(), "'", ""))
    email = Map.get(user_params, :email, String.replace(Faker.Internet.email(), "'", ""))
    password = get_password(user_params)

    attributes = %{
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    }

    %Micropost.User{} |> Micropost.User.changeset(attributes)
  end
end
