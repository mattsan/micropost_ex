defmodule MicropostWeb.SignupTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  alias Micropost.{Repo, User}

  hound_session()

  @name "Example User"
  @email "user@example.com"
  @password "foobar"

  defp visit_signup(%{conn: conn}) do
    navigate_to(user_path(conn, :new))

    :ok
  end

  defp fill_signup_fields(_context) do
    fill_field({:name, "user[name]"}, @name)
    fill_field({:name, "user[email]"}, @email)
    fill_field({:name, "user[password]"}, @password)
    fill_field({:name, "user[password_confirmation]"}, @password)

    :ok
  end

  defp submit(_context) do
    find_element(:xpath, "//button")
    |> click()

    :ok
  end

  defp count_user(context) do
    user_counts = Map.get(context, :user_counts, [])
    count = Repo.aggregate(User, :count, :id)
    [user_counts: [count|user_counts]]
  end

  describe "signup with invalid infomation" do
    setup [:visit_signup, :submit]

    test "should have title 'Sign up'" do
      assert page_title() =~ "Sign up"
    end

    test "should have error message" do
      assert inner_text(find_element(:tag, "body")) =~ "error"
    end
  end

  describe "signup with valid infomation" do
    setup [:visit_signup, :fill_signup_fields, :count_user, :submit, :count_user]

    test "should not create a user", %{user_counts: [after_count, before_count]} do
      assert (after_count - before_count) == 1
    end

    test "should have title with user name" do
      assert page_title() =~ "Example User"
    end

    test "should have flash message" do
      assert inner_text(find_element(:class, "alert-success")) =~ "Welcome"
    end
  end
end
