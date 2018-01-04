defmodule Micropost.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Micropost.User

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, max: 50)
    |> validate_format(:email, @valid_email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unsafe_validate_unique(:email, Micropost.Repo)
  end
end
