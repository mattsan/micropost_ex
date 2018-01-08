defmodule MicropostWeb.Router do
  use MicropostWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MicropostWeb do
    pipe_through :browser # Use the default browser stack

    get "/", StaticPageController, :home
    get "/help", StaticPageController, :help
    get "/about", StaticPageController, :about
    get "/contact", StaticPageController, :contact

    get "/signup", UserController, :new
    get "/signin", SessionController, :new
    resources "/sessions", SessionController, only: [:create]
    resources "/users", UserController, only: [:create]

    scope "/" do
      pipe_through :assign_current_user

      delete "/signout", SessionController, :delete
      resources "/users", UserController, only: [:index, :show]

      scope "/" do
        pipe_through :signed_in_user

        resources "/users", UserController, only: [:edit, :update]
      end
      end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MicropostWeb do
  #   pipe_through :api
  # end

  defp assign_current_user(conn, _) do
    remember_token = get_session(conn, :remember_token)
    current_user = remember_token && Micropost.User.get_by(remember_token: remember_token)

    if current_user do
      assign(conn, :current_user, current_user)
    else
      redirect(conn, to: MicropostWeb.Router.Helpers.session_path(conn, :new))
      |> halt()
    end
  end

  defp signed_in_user(conn, _) do
    if String.to_integer(conn.params["id"]) == conn.assigns.current_user.id do
      conn
    else
      redirect(conn, to: MicropostWeb.Router.Helpers.user_path(conn, :show, conn.assigns.current_user))
      |> halt()
    end
  end
end
