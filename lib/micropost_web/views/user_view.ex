defmodule MicropostWeb.UserView do
  use MicropostWeb, :view

  def page_title(%{private: %{phoenix_action: :new}}), do: "Sign up"
  def page_title(%{private: %{phoenix_action: :create}}), do: "Sign up"
  def page_title(%{private: %{phoenix_action: :edit}}), do: "Edit user"
  def page_title(%{private: %{phoenix_action: :update}}), do: "Edit user"
  def page_title(%{assigns: %{user: user}}), do: user.name
  def page_title(_), do: nil

  def gravatar_for(user, options \\ []) do
    size = Keyword.get(options, :size, 50)
    gravatar_id = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    img_tag(gravatar_url)
  end

  def submit_caption(%{private: %{phoenix_action: :edit}}), do: "Save change"
  def submit_caption(_), do: "Create my account"
end
