defmodule MicropostWeb.AuthenticationTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  alias Micropost.User

  @name "Example User"
  @email "user@example.com"
  @password "foobar"
  @user_params %{name: @name, email: @email, password: @password, password_confirmation: @password}

  hound_session()

  defp create_user(_context) do
    {:ok, user} = User.insert(User.changeset(%User{}, @user_params))

    [user: user]
  end

  defp visit_signin(%{conn: conn}) do
    navigate_to(session_path(conn, :new))

    :ok
  end

  defp fill_information(_context) do
    fill_field({:name, "user[email]"}, @email)
    fill_field({:name, "user[password]"}, @password)

    :ok
  end

  defp submit(_context) do
    find_element(:xpath, "//button")
    |> click()

    :ok
  end

  describe "visit signup_path" do
    setup :visit_signin

    test "should have title 'Sign in'" do
      assert page_title() =~ "Sign in"
    end

    test "should have 'Sign in' in body" do
      assert inner_text(find_element(:tag, "body")) =~ "Sign in"
    end
  end

  describe "signin with invalid information" do
    setup [:visit_signin, :submit]

    test "should have title 'Sign in'" do
      assert page_title() =~ "Sign in"
    end

    test "should have text 'invalid'" do
      assert inner_text(find_element(:class, "alert-danger")) =~ "Invalid"
    end

    test "should have link 'Sign in'" do
      assert attribute_value(find_element(:link_text, "Sign in"), "href") == session_url(MicropostWeb.Endpoint, :new)
    end

    test "should not have link to profile page" do
      assert find_all_elements(:link_text, "Profile") == []
      assert find_all_elements(:link_text, "Settings") == []
      assert find_all_elements(:link_text, "Sign out") == []
    end
  end

  describe "signin with valid information" do
    setup [:create_user, :visit_signin, :fill_information, :submit]

    test "should have user name in title", %{user: user} do
      assert page_title() =~ user.name
    end

    test "should have flash message" do
      assert inner_text(find_element(:class, "alert-success")) =~ "Welcome back!"
    end

    test "should have link to profile page", %{user: user} do
      assert attribute_value(find_element(:link_text, "Profile"), "href") == user_url(MicropostWeb.Endpoint, :show, user)
      assert attribute_value(find_element(:link_text, "Settings"), "href") == user_url(MicropostWeb.Endpoint, :edit, user)
      assert attribute_value(find_element(:link_text, "Sign out"), "data-to") == session_path(MicropostWeb.Endpoint, :delete)
    end

    test "should not have link 'Sign in" do
      assert find_all_elements(:link_text, "Sign in") == []
    end

    test "followed by signout" do
      find_element(:link_text, "Sign out")
      |> click

      assert attribute_value(find_element(:link_text, "Sign in"), "href") == session_url(MicropostWeb.Endpoint, :new)
    end
  end
end
