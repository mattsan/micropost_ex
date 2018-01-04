defmodule Micropost.UserTest do
  use Micropost.DataCase

  alias Micropost.{Repo, User}

  @name "Example User"
  @email "user@example.com"

  describe "validation" do
    test "when name and email is present" do
      changeset = User.changeset(%User{}, %{name: @name, email: @email})
      assert changeset.valid?
    end

    test "when name is not present" do
      changeset = User.changeset(%User{}, %{name: " ", email: @email})
      assert changeset.valid? == false
    end

    test "when email is not present" do
      changeset = User.changeset(%User{}, %{name: @name, email: " "})
      assert changeset.valid? == false
    end

    test "when naem is too long" do
      changeset = User.changeset(%User{}, %{name: String.duplicate("a", 51), email: @email})
      assert changeset.valid? == false
    end

    test "when email format is invalid" do
      ~w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com)
      |> Enum.each(fn invalid_address ->
        changeset = User.changeset(%User{}, %{name: @name, email: invalid_address})
        assert changeset.valid? == false
      end)
    end

    test "when email format is valid" do
      ~w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      |> Enum.each(fn valid_address ->
        changeset = User.changeset(%User{}, %{name: @name, email: valid_address})
        assert changeset.valid?
      end)
    end

    test "when email address is already taken" do
      Repo.insert(%User{name: @name, email: @email})
      changeset = User.changeset(%User{}, %{name: "Example User Jr.", email: String.upcase(@email)})
      assert changeset.valid? == false
    end
  end
end
