defmodule MicropostWeb.SettingsTest do
  use MicropostWeb.ConnCase
  use Hound.Helpers

  hound_session()

  defp visit_signin(%{conn: conn}) do
    navigate_to(session_path(conn, :new))

    :ok
  end

  defp fill_signin_fields(%{user: user}) do
    fill_field({:name, "user[email]"}, user.email)
    fill_field({:name, "user[password]"}, default_password())

    :ok
  end

  defp visit_settings(%{conn: conn, user: user}) do
    navigate_to(user_path(conn, :edit, user))

    :ok
  end

  defp fill_settings_fields(%{settings_params: settings_params}) do
    fill_field({:name, "user[name]"}, settings_params.name)
    fill_field({:name, "user[email]"}, settings_params.email)
    fill_field({:name, "user[password]"}, settings_params.password)
    fill_field({:name, "user[password_confirmation]"}, settings_params.password)

    :ok
  end

  defp submit(_) do
    find_element(:xpath, "//button")
    |> click()

    :ok
  end

  setup [:create_user, :visit_signin, :fill_signin_fields, :submit]

  describe "with invalid information" do
    setup [:visit_settings, :submit]

    test "should have error message" do
      assert inner_text(find_element(:class, "alert-danger")) =~ "error"
    end
  end

  describe "with valid information" do
    setup [:visit_settings, :fill_settings_fields, :submit]

    @tag settings_params: %{name: "New Name", email: "new@example.com", password: "barfoo"}
    test "should be updated profile" do
      assert page_title() =~ "New Name"
      assert inner_text(find_element(:class, "alert-success")) =~ "Profile updated"
      assert attribute_value(find_element(:link_text, "Sign out"), "data-to") == session_path(MicropostWeb.Endpoint, :delete)
    end
  end
end
