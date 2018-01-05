defmodule MicropostWeb.StaticPageView do
  use MicropostWeb, :view

  def page_title(%{private: %{phoenix_action: :help}}), do: "Help"
  def page_title(%{private: %{phoenix_action: :about}}), do: "About Us"
  def page_title(%{private: %{phoenix_action: :contact}}), do: "Contact"
  def page_title(_), do: nil
end
