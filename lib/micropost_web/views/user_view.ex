defmodule MicropostWeb.UserView do
  use MicropostWeb, :view

  def page_title(%{private: %{phoenix_action: :new}}), do: "Sign up"
  def page_title(%{assigns: %{user: user}}), do: user.name
  def page_title(_), do: nil

  def gravatar_for(user) do
    gravatar_id = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    img_tag(gravatar_url)
  end
end
