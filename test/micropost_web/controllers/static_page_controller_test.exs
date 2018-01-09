defmodule MicropostWeb.StaticPageControllerTest do
  use MicropostWeb.ConnCase

  import MicropostWeb.Router.Helpers

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  defp full_title, do: @base_title
  defp full_title(page_title), do: "#{@base_title} | #{page_title}"

  describe "root page" do
    @describetag path: static_page_path(build_conn(), :home)
    setup :visit

    test "should have the content 'Sample App'", %{response: response} do
      assert response =~ "Sample App"
    end

    test "should have the base title", %{response: response} do
      assert response =~ "<title>#{full_title()}</title>"
    end
  end

  describe "help page" do
    @describetag path: static_page_path(build_conn(), :help)
    setup :visit

    test "should have the contnt 'Help'", %{response: response} do
      assert response =~ "Help"
    end

    test "should have the help title", %{response: response} do
      assert response =~ "<title>#{full_title("Help")}</title>"
    end
  end

  describe "about page" do
    @describetag path: static_page_path(build_conn(), :about)
    setup :visit

    test "should have the contnt 'About Us'", %{response: response} do
      assert response =~ "About Us"
    end

    test "should have the about title", %{response: response} do
      assert response =~ "<title>#{full_title("About Us")}</title>"
    end
  end

  describe "contact page" do
    @describetag path: static_page_path(build_conn(), :contact)
    setup :visit

    test "should have the content 'Contact'", %{response: response} do
      assert response =~ "Contact"
    end

    test "should have the content title", %{response: response} do
      assert response =~ "<title>#{full_title("Contact")}</title>"
    end
  end
end
