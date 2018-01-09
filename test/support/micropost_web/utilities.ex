defmodule MicropostWeb.Utilities do
  use Phoenix.ConnTest
  import MicropostWeb.Router.Helpers

  @endpoint MicropostWeb.Endpoint

  def visit(%{conn: conn, path: path} = context) do
    status_code = Map.get(context, :status, 200)
    response = conn
      |> get(path)
      |> html_response(status_code)
    [response: response]
  end

  def sign_in(%{conn: conn, user: user} = context) do
    password = Map.get(context, :password, Micropost.Utilities.default_password)
    posted_conn = post(conn, session_path(conn, :create), user: %{email: user.email, password: password})
    [conn: posted_conn]
  end
end
