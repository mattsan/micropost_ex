defmodule Micropost.Repo.Migrations.AddRememberTokenToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :remember_token, :string
    end

    create index("users", [:remember_token])
  end
end
