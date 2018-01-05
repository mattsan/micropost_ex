defmodule MicropostWeb.UserControllerTest do
  use MicropostWeb.ConnCase

  import MicropostWeb.Router.Helpers

  def get_response(conn, action) do
    conn
    |> get(user_path(conn, action))
    |> html_response(200)
  end

  describe "signup page" do
    test "should have content 'Sign up'", %{conn: conn} do
      response = get_response(conn, :new)
      assert response =~ "Sign up"
    end

    test "should have title Sign up", %{conn: conn} do
      response = get_response(conn, :new)
      assert response =~ "Sign up</title>"
    end
  end
end
