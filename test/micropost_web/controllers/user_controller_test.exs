defmodule MicropostWeb.UserControllerTest do
  use MicropostWeb.ConnCase

  @gravatar_url "http://gravatar.com/emails"

  describe "visit sign up page" do
    @describetag path: user_path(build_conn(), :new)
    setup :visit

    test "should have content 'Sign up'", %{response: response} do
      assert response =~ "<h1>Sign up</h1>"
    end

    test "should have title Sign up", %{response: response} do
      assert response =~ ~r/<title>.*Sign up.*<\/title>/
    end
  end

  describe "a signed-in user" do
    setup [:create_user, :create_user, :sign_in]

    test "show profiile page", %{conn: conn, user: user} do
      response = conn
        |> get(user_path(conn, :show, user))
        |> html_response(200)

      assert response =~ ~r/<title>.*#{user.name}.*<\/title>/
    end

    test "show settings page", %{conn: conn, user: user} do
      response = conn
        |> get(user_path(conn, :edit, user))
        |> html_response(200)

      assert response =~ ~r/<title>.*Edit user.*<\/title>/
      assert response =~ "<h1>Update your profile</h1>"
      assert response =~ @gravatar_url
    end

    test "show another users's settings page", %{conn: conn, users: [myself, another]} do
      path = conn
        |> get(user_path(conn, :edit, another))
        |> redirected_to()

      assert path == user_path(conn, :show, myself)
    end

    test "update with valid information", %{conn: conn, user: user} do
      user_params = %{
        name: "New Name",
        email: "new@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      }

      patched_conn = patch(conn, user_path(conn, :update, user), user: user_params)
      assert redirected_to(patched_conn) == user_path(conn, :show, user)
      assert get_flash(patched_conn)["success"] =~ "updated"
    end

    test "update with invalid information", %{conn: conn, user: user} do
      user_params = %{
        name: user.name,
        email: user.email,
        password: "foobar",
        password_confirmation: "barfoo"
      }

      patched_conn = patch(conn, user_path(conn, :update, user), user: user_params)
      assert redirected_to(patched_conn) == user_path(conn, :edit, user)
      assert get_flash(patched_conn)["error"] =~ "error"
    end

    test "update another users's settings", %{conn: conn, users: [myself, another]} do
      user_params = %{
        name: myself.name,
        email: myself.email,
        passowrd: "foobar",
        password_confirmation: "foobar"
      }

      path = conn
        |> patch(user_path(conn, :update, another), user: user_params)
        |> redirected_to()

      assert path == user_path(conn, :show, myself)
    end
  end

  describe "a non-signed-in user" do
    setup :create_user

    test "show profiile page", %{conn: conn, user: user} do
      redirected_conn = get(conn, user_path(conn, :show, user))

      assert redirected_to(redirected_conn) == session_path(conn, :new)
    end

    test "show settings page", %{conn: conn, user: user} do
      redirected_conn = get(conn, user_path(conn, :edit, user))

      assert redirected_to(redirected_conn) == session_path(conn, :new)
    end
  end
end
