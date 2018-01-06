defmodule MicropostWeb.UserControllerTest do
  use MicropostWeb.ConnCase

  alias Micropost.{Repo, User}

  import MicropostWeb.Router.Helpers

  @attributes %{
    name: "Michael Hart",
    email: "michael@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  }

  def get_signup(%{conn: conn} = _content) do
    response = conn
      |> get(user_path(conn, :new))
      |> html_response(200)
    [response: response]
  end

  def get_profile(%{conn: conn, user: user} = _content) do
    response = conn
      |> get(user_path(conn, :show, user.id))
      |> html_response(200)
    [response: response]
  end

  def create_user(_context) do
    user = %User{}
      |> User.changeset(@attributes)
      |> Repo.insert!()
    [user: user]
  end

  describe "signup page" do
    setup :get_signup

    test "should have content 'Sign up'", %{response: response} do
      assert response =~ "Sign up"
    end

    test "should have title Sign up", %{response: response} do
      assert response =~ "Sign up</title>"
    end
  end

  describe "profile page" do
    setup [:create_user, :get_profile]

    test "should have a name in content", %{user: user, response: response} do
      assert response =~ user.name
    end

    test "should have a name in title", %{user: user, response: response} do
      assert response =~ "#{user.name}</title>"
    end
  end
end
