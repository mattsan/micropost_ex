defmodule MicropostWeb.LayoutView do
  use MicropostWeb, :view

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  def full_title(view_module, view_template) do
    full_title(view_module, view_template, function_exported?(view_module, :page_title, 1))
  end

  defp full_title(view_module, view_template, true), do: full_title(view_module.page_title(view_template))
  defp full_title(_, _, false), do: @base_title

  defp full_title(nil), do: @base_title
  defp full_title(page_title), do: "#{@base_title} | #{page_title}"
end
