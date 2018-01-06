defmodule MicropostWeb.SessionView do
  use MicropostWeb, :view

  def page_title(%{assigns: %{user: user}}), do: user.name
  def page_title(_), do: "Sign in"
end
