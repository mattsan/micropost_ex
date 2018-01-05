use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :micropost, MicropostWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :micropost, Micropost.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "micropost_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4
config :hound, driver: "phantomjs"
