defmodule MicropostWeb.LayoutView do
  use MicropostWeb, :view

  @base_title "Ruby on Rails Tutorial rewritten by Phoenix Framework"

  def full_title(view_module, view_template) do
    full_title(view_module, view_template, function_exported?(view_module, :page_title, 1))
  end

  defp full_title(view_module, view_template, true) do
    full_title(view_module, view_template, view_module.page_title(view_template))
  end

  defp full_title(view_module, view_template, false), do: @base_title
  defp full_title(view_module, view_template, nil), do: @base_title
  defp full_title(view_module, view_template, page_title), do: "#{@base_title} | #{page_title}"
end
