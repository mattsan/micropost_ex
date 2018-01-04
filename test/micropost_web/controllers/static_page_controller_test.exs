defmodule MicropostWeb.StaticPageControllerTest do
  use MicropostWeb.ConnCase

  test "GET /home", %{conn: conn} do
    conn = get conn, "/home"
    response = html_response(conn, 200)
    assert response =~ "Sample App"
    assert response =~ "<title>Ruby on Rails Tutorial rewritten by Phoenix Framework | Home</title>"
  end

  test "GET /help", %{conn: conn} do
    conn = get conn, "/help"
    response = html_response(conn, 200)
    assert response =~ "Help"
    assert response =~ "<title>Ruby on Rails Tutorial rewritten by Phoenix Framework | Help</title>"
  end

  test "GET /about", %{conn: conn} do
    conn = get conn, "/about"
    response = html_response(conn, 200)
    assert response =~ "About Us"
    assert response =~ "<title>Ruby on Rails Tutorial rewritten by Phoenix Framework | About Us</title>"
  end
end
