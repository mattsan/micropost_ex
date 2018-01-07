defmodule MicropostWeb.LayoutView do
  use MicropostWeb, :view

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  def full_title(conn, view_module) do
    full_title(conn, view_module, function_exported?(view_module, :page_title, 1))
  end

  def current_user(conn) do
    email = Plug.Conn.get_session(conn, :remember_token)
    email && Micropost.User.get_by(email: email)
  end

  def sign_in?(conn) do
    !!current_user(conn)
  end

  defp full_title(conn, view_module, true), do: full_title(view_module.page_title(conn))
  defp full_title(_, _, false), do: @base_title

  defp full_title(nil), do: @base_title
  defp full_title(page_title), do: "#{@base_title} | #{page_title}"
end
