defmodule MicropostWeb.AuthenticationTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  hound_session()

  defp visit_signin(%{conn: conn}) do
    navigate_to(session_path(conn, :new))

    :ok
  end

  defp fill_information(%{user: user}) do
    fill_field({:name, "user[email]"}, user.email)
    fill_field({:name, "user[password]"}, "foobar")

    :ok
  end

  defp submit(_context) do
    find_element(:xpath, "//button")
    |> click()

    :ok
  end

  describe "signin with invalid information" do
    setup [:visit_signin, :submit]

    test "should fail sign in and show sign in page" do
      assert page_title() =~ "Sign in"
      assert inner_text(find_element(:class, "alert-danger")) =~ "Invalid"
      assert attribute_value(find_element(:link_text, "Sign in"), "href") == session_url(MicropostWeb.Endpoint, :new)
      assert find_all_elements(:link_text, "Profile") == []
      assert find_all_elements(:link_text, "Settings") == []
      assert find_all_elements(:link_text, "Sign out") == []
    end
  end

  describe "signin with valid information" do
    setup [:create_user, :visit_signin, :fill_information, :submit]

    test "should have signed in ", %{user: user} do
      assert page_title() =~ user.name
      assert inner_text(find_element(:class, "alert-success")) =~ "Welcome back!"
      assert attribute_value(find_element(:link_text, "Profile"), "href") == user_url(MicropostWeb.Endpoint, :show, user)
      assert attribute_value(find_element(:link_text, "Settings"), "href") == user_url(MicropostWeb.Endpoint, :edit, user)
      assert attribute_value(find_element(:link_text, "Sign out"), "data-to") == session_path(MicropostWeb.Endpoint, :delete)
      assert find_all_elements(:link_text, "Sign in") == []
    end

    test "followed by signout" do
      find_element(:link_text, "Sign out")
      |> click

      assert attribute_value(find_element(:link_text, "Sign in"), "href") == session_url(MicropostWeb.Endpoint, :new)
    end
  end
end
