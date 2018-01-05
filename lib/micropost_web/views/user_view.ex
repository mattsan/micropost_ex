defmodule MicropostWeb.UserView do
  use MicropostWeb, :view

  def page_title(%{private: %{phoenix_action: :new}}), do: "Sign up"
  def page_title(%{assigns: %{user: user}}), do: user.name
  def page_title(_), do: nil
end
