defmodule Micropost.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt.Base
  import Bcrypt
  alias Micropost.User

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_digest, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_length(:name, max: 50)
    |> validate_format(:email, @valid_email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unsafe_validate_unique(:email, Micropost.Repo)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> digest_password()
  end

  def authenticated?(user, password) do
    verify_pass(password, user.password_digest)
  end

  defp digest_password(changeset), do: digest_password(changeset, get_change(changeset, :password))
  defp digest_password(changeset, nil), do: changeset
  defp digest_password(changeset, password), do: put_change(changeset, :password_digest, digest(password))

  def digest(phrase) do
    hash_password(phrase, gen_salt())
  end
end
