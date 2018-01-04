defmodule MicropostWeb.StaticPageView do
  use MicropostWeb, :view

  def page_title("help.html"), do: "Help"
  def page_title("about.html"), do: "About Us"
  def page_title("contact.html"), do: "Contact"
  def page_title(_), do: nil
end
