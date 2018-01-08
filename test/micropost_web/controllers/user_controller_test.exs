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
    {:ok, user} = %Micropost.User{}
      |> Micropost.User.changeset(@attributes)
      |> Micropost.User.insert()
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
end
