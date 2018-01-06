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
    get "/signup", UserController, :new
    get "/signin", SessionController, :new
    delete "/signout", SessionController, :delete
    get "/help", StaticPageController, :help
    get "/about", StaticPageController, :about
    get "/contact", StaticPageController, :contact

    resources "/users", UserController, except: [:new]
    resources "/sessions", SessionController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MicropostWeb do
  #   pipe_through :api
  # end
end
