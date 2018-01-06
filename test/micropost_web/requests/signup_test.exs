defmodule MicropostWeb.SignupTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  alias Micropost.{Repo, User}

  hound_session()

  defp visit_signup(%{conn: conn} = _context) do
    navigate_to(user_path(conn, :new))
    :ok
  end

  defp fill_signup_field do
    fill_field({:name, "user[name]"}, "Example User")
    fill_field({:name, "user[email]"}, "user@example.com")
    fill_field({:name, "user[password]"}, "foobar")
    fill_field({:name, "user[password_confirmation]"}, "foobar")
  end

  describe "signup with invalid infomation" do
    setup :visit_signup

    test "should have title 'Sign up'" do
      find_element(:xpath, "//button")
      |> click()

      assert page_title() =~ "Sign up"
      assert inner_text(find_element(:tag, "body")) =~ "error"
    end
  end

  describe "signup with valid infomation" do
    setup :visit_signup

    test "should not create a user" do
      before_count = Repo.aggregate(User, :count, :id)

      fill_signup_field()
      find_element(:xpath, "//button")
      |> click()

      after_count = Repo.aggregate(User, :count, :id)

      assert (after_count - before_count) == 1
    end

    test "should have title with user name" do
      fill_signup_field()
      find_element(:xpath, "//button")
      |> click()

      assert page_title() =~ "Example User"
      assert inner_text(find_element(:class, "alert-success")) =~ "Welcome"
    end
  end
end
