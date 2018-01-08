defmodule MicropostWeb.SettingsTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  hound_session()

  defp signin(%{conn: conn, user: user} = context) do
    navigate_to(session_path(conn, :new))
    fill_field({:name, "user[email]"}, user.email)
    fill_field({:name, "user[password]"}, "foobar")
    submit(context)
    :ok
  end

  defp visit_settings(%{conn: conn, user: user}) do
    navigate_to(user_path(conn, :edit, user))

    :ok
  end

  defp fill_settings_fields(%{user_params: user_params}) do
    fill_field({:name, "user[name]"}, user_params.name)
    fill_field({:name, "user[email]"}, user_params.email)
    fill_field({:name, "user[password]"}, user_params.password)
    fill_field({:name, "user[password_confirmation]"}, user_params.password)

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
      assert inner_text(find_element(:class, "alert-error")) =~ "error"
    end
  end

  describe "with valid information" do
    setup [:create_user, :signin, :visit_settings]
    setup do: [user_params: %{name: "New Name", email: "new@example.com", password: "barfoo"}]
    setup [:fill_settings_fields, :submit]

    test "should be updated profile" do
      assert page_title() =~ "New Name"
      assert inner_text(find_element(:class, "alert-success")) =~ "Profile updated"
      assert attribute_value(find_element(:link_text, "Sign out"), "data-to") == session_path(MicropostWeb.Endpoint, :delete)
    end
  end
end
