defmodule MicropostWeb.SessionControllerTest do
  use MicropostWeb.ConnCase

  describe "visit sign in page" do
    @describetag path: session_path(build_conn(), :new)
    setup :visit

    test "should have title 'Sign in'", %{response: response} do
      assert response =~ ~r/<title>.+Sign in<\/title>/
    end

    test "should have 'Sign in' in body", %{response: response} do
      assert response =~ "<h1>Sign in</h1>"
    end
  end

  describe "sign in valid" do
    setup [:create_user, :sign_in]

    test "with valid information", %{conn: conn, user: user} do
      assert redirected_to(conn) == user_path(conn, :show, user)
    end
  end

  describe "sign in invalid" do
    setup [:create_user, :sign_in]

    @tag password: "barfoo"
    test "with invalid information", %{conn: conn} do
      assert redirected_to(conn) == session_path(conn, :new)
      assert get_flash(conn)["error"] =~ "Invalid"
    end
  end
end
