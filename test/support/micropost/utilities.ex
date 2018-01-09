defmodule Micropost.Utilities do
  use Phoenix.ConnTest

  @default_password "foobar"

  def default_password do
    @default_password
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

  defp new_changeset(context) do
    user_params = Map.get(context, :user_params, %{})

    name = Map.get(user_params, :name, String.replace(Faker.Name.name(), "'", ""))
    email = Map.get(user_params, :email, String.replace(Faker.Internet.email(), "'", ""))
    password = Map.get(user_params, :password, @default_password)

    attributes = %{
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    }

    %Micropost.User{} |> Micropost.User.changeset(attributes)
  end
end
