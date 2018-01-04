defmodule MicropostWeb.LayoutView do
  use MicropostWeb, :view

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  def full_title, do: @base_title
  def full_title(nil), do: @base_title
  def full_title(page_title), do: "#{@base_title} | #{page_title}"
end
