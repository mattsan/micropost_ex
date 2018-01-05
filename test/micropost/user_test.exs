defmodule Micropost.UserTest do
  use Micropost.DataCase

  alias Micropost.{Repo, User}

  @name "Example User"
  @email "user@example.com"
  @password "foobar"
  @user %User{name: @name, email: @email, password: @password, password_confirmation: @password}

  defp insert_user(_context) do
    user = Repo.insert!(User.changeset(%User{}, %{name: @name, email: @email, password: @password, password_confirmation: @password}))
    [user: user]
  end

  describe "validation" do
    test "when name and email is present" do
      changeset = User.changeset(@user, %{})
      assert changeset.valid?
    end

    test "when name is not present" do
      changeset = User.changeset(@user, %{name: " "})
      refute changeset.valid?
    end

    test "when email is not present" do
      changeset = User.changeset(@user, %{email: " "})
      refute changeset.valid?
    end

    test "when naem is too long" do
      changeset = User.changeset(@user, %{name: String.duplicate("a", 51)})
      refute changeset.valid?
    end

    test "when email format is invalid" do
      ~w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com)
      |> Enum.each(fn invalid_address ->
        changeset = User.changeset(@user, %{email: invalid_address})
        refute changeset.valid?
      end)
    end

    test "when email format is valid" do
      ~w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      |> Enum.each(fn valid_address ->
        changeset = User.changeset(@user, %{email: valid_address})
        assert changeset.valid?
      end)
    end
  end

  describe "validation / a user already exists" do
    setup :insert_user

    test "when email address is already taken" do
      changeset = User.changeset(@user, %{name: "Example User Jr.", email: String.upcase(@email)})
      refute changeset.valid?
    end
  end

  describe "password" do
    test "when password is not present" do
      changeset = User.changeset(@user, %{password: " "})
      refute changeset.valid?
    end

    test "when password is too short" do
      changeset = User.changeset(@user, %{password: String.duplicate("a", 5)})
      refute changeset.valid?
    end

    test "when password confirmation is not present" do
      changeset = User.changeset(@user, %{password_confirmation: " "})
      refute changeset.valid?
    end
  end

  describe "authentication" do
    setup :insert_user

    test "when valid passowrd", context do
      assert User.authenticated?(context[:user], @password)
    end

    test "when invalid passowrd", context do
      refute User.authenticated?(context[:user], "invalid")
    end
  end
end
