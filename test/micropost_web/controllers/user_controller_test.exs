defmodule MicropostWeb.UserControllerTest do
  use MicropostWeb.ConnCase

  import MicropostWeb.Router.Helpers

  @attributes %{
    name: "Michael Hart",
    email: "michael@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  }

  def create_user(_context) do
    user = %Micropost.User{}
      |> Micropost.User.changeset(@attributes)
      |> Micropost.Repo.insert!()
    [user: user]
  end

  describe "signup page" do
    setup %{conn: conn}, do: [path: user_path(conn, :new)]
    setup :visit

    test "should have content 'Sign up'", %{response: response} do
      assert response =~ "Sign up"
    end

    test "should have title Sign up", %{response: response} do
      assert response =~ "Sign up</title>"
    end
  end

  describe "profile page" do
    setup :create_user
    setup %{conn: conn, user: user}, do: [path: user_path(conn, :show, user)]
    setup :visit

    test "should have a name in content", %{user: user, response: response} do
      assert response =~ user.name
    end

    test "should have a name in title", %{user: user, response: response} do
      assert response =~ "#{user.name}</title>"
    end
  end
end
