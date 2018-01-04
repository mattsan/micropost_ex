defmodule MicropostWeb.StaticPageControllerTest do
  use MicropostWeb.ConnCase

  import MicropostWeb.Router.Helpers

  def get_response(conn, page) do
    conn
    |> get(static_page_path(conn, page))
    |> html_response(200)
  end

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  def full_title, do: @base_title
  def full_title(page_title), do: "#{@base_title} | #{page_title}"

  describe "root page" do
    test "should have the content 'Sample App'", %{conn: conn} do
      response = get_response(conn, :home)
      assert response =~ "Sample App"
    end

    test "should have the base title", %{conn: conn} do
      response = get_response(conn, :home)
      assert response =~ "<title>#{full_title()}</title>"
    end
  end

  describe "help page" do
    test "should have the contnt 'Help'", %{conn: conn} do
      response = get_response(conn, :help)
      assert response =~ "Help"
    end

    test "should have the help title", %{conn: conn} do
      response = get_response(conn, :help)
      assert response =~ "<title>#{full_title("Help")}</title>"
    end
  end

  describe "about page" do
    test "should have the contnt 'About Us'", %{conn: conn} do
      response = get_response(conn, :about)
      assert response =~ "About Us"
    end

    test "should have the about title", %{conn: conn} do
      response = get_response(conn, :about)
      assert response =~ "<title>#{full_title("About Us")}</title>"
    end
  end

  describe "contact page" do
    test "should have the content 'Contact'", %{conn: conn} do
      response = get_response(conn, :contact)
      assert response =~ "Contact"
    end

    test "should have the content title", %{conn: conn} do
      response = get_response(conn, :contact)
      assert response =~ "<title>#{full_title("Contact")}</title>"
    end
  end
end
