defmodule MicropostWeb.SettingsTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  alias Micropost.User

  hound_session()

  @name "Example User"
  @email "user@example.com"
  @password "foobar"
  @user_params %{name: @name, email: @email, password: @password, password_confirmation: @password}

  defp create_user(_context) do
    {:ok, user} = User.insert(User.changeset(%User{}, @user_params))

    [user: user]
  end

  defp signin(%{conn: conn} = context) do
    navigate_to(session_path(conn, :new))
    fill_field({:name, "user[email]"}, @email)
    fill_field({:name, "user[password]"}, @password)
    submit(context)
    :ok
  end

  defp visit_settings(%{conn: conn, user: user}) do
    navigate_to(user_path(conn, :edit, user))

    :ok
  end

  defp fill_settings_fields(%{user: user}) do
    fill_field({:name, "user[name]"}, user.name)
    fill_field({:name, "user[email]"}, user.email)
    fill_field({:name, "user[password]"}, user.password)
    fill_field({:name, "user[password_confirmation]"}, user.password)

    :ok
  end

  defp submit(_context) do
    find_element(:xpath, "//button")
    |> click()

    :ok
  end

  describe "with invalid information" do
    setup [:create_user, :signin, :visit_settings, :submit]

    test "should have error message" do
      assert inner_text(find_element(:tag, "body")) =~ "error"
    end
  end

  describe "with valid information" do
    setup [:create_user, :signin, :visit_settings]
    setup do: [user: %{name: "New Name", email: "new@example.com", password: "barfoo"}]
    setup [:fill_settings_fields, :submit]

    test "should have title new user name" do
      assert page_title() =~ "New Name"
    end

    test "should have updated message" do
      assert inner_text(find_element(:class, "alert-success")) =~ "Profile updated"
    end

    test "should have link to sign out" do
      assert attribute_value(find_element(:link_text, "Sign out"), "data-to") == session_path(MicropostWeb.Endpoint, :delete)
    end
  end
end
