defmodule Micropost.UserTest do
  use Micropost.DataCase

  alias Micropost.{Repo, User}

  @name "Example User"
  @email "user@example.com"
  @password "foobar"
  @user_params %{name: @name, email: @email, password: @password, password_confirmation: @password}

  defp new_user(_context) do
    user = %User{} |> User.changeset(@user_params) |> Ecto.Changeset.apply_changes()
    [user: user]
  end

  defp create_user(_context) do
    user = Repo.insert!(User.changeset(%User{}, @user_params))
    [user: user]
  end

  describe "validation" do
    setup :new_user

    test "when name and email is present", %{user: user} do
      changeset = User.changeset(user, %{})
      assert changeset.valid?
    end

    test "when name is not present", %{user: user} do
      changeset = User.changeset(user, %{name: " "})
      refute changeset.valid?
    end

    test "when email is not present", %{user: user} do
      changeset = User.changeset(user, %{email: " "})
      refute changeset.valid?
    end

    test "when naem is too long", %{user: user} do
      changeset = User.changeset(user, %{name: String.duplicate("a", 51)})
      refute changeset.valid?
    end

    test "when email format is invalid", %{user: user} do
      ~w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com)
      |> Enum.each(fn invalid_address ->
        changeset = User.changeset(user, %{email: invalid_address})
        refute changeset.valid?
      end)
    end

    test "when email format is valid", %{user: user} do
      ~w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      |> Enum.each(fn valid_address ->
        changeset = User.changeset(user, %{email: valid_address})
        assert changeset.valid?
      end)
    end
  end

  describe "validation / a user already exists" do
    setup :create_user

    test "when email address is already taken" do
      changeset = User.changeset(%User{}, %{@user_params|name: "Example User Jr."})
      refute changeset.valid?
    end
  end

  describe "password" do
    setup :new_user

    test "when password is not present", %{user: user} do
      changeset = User.changeset(user, %{password: " "})
      refute changeset.valid?
    end

    test "when password is too short", %{user: user} do
      changeset = User.changeset(user, %{password: String.duplicate("a", 5)})
      refute changeset.valid?
    end

    test "when password confirmation is not present", %{user: user} do
      changeset = User.changeset(user, %{password_confirmation: " "})
      refute changeset.valid?
    end
  end

  describe "authentication" do
    setup :create_user

    test "when valid passowrd", %{user: user} do
      assert User.authenticated?(user, @password)
    end

    test "when invalid passowrd", %{user: user} do
      refute User.authenticated?(user, "invalid")
    end
  end
end
