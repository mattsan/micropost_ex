defmodule Micropost.UserTest do
  use Micropost.DataCase

  alias Micropost.User

  defp new_changeset(%{user: user, params: params}) do
    [changeset: User.changeset(user, params)]
  end

  describe "validation" do
    setup [:new_user, :new_changeset]

    @tag params: %{name: "foo", email: "foo@example.com"}
    test "when name and email is present", %{changeset: changeset} do
      assert changeset.valid?
    end

    @tag params: %{name: " "}
    test "when name is not present", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{name: String.duplicate("a", 51)}
    test "when name is too long", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{password: " "}
    test "when password is not present", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{password: String.duplicate("a", 5), password_confirmation: String.duplicate("a", 5)}
    test "when password is too short", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{password_confirmation: " "}
    test "when password confirmation is not present", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{password: "foobar", password_confirmation: "FOOBAR"}
    test "when password is not confirmed", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag params: %{email: " "}
    test "when email is not present", %{changeset: changeset} do
      refute changeset.valid?
    end

    ~w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com)
    |> Enum.each(fn invalid_address ->
      @tag params: %{email: invalid_address}
      test "when email is '#{invalid_address}'", %{changeset: changeset} do
        refute changeset.valid?
      end
    end)

    ~w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
    |> Enum.each(fn valid_address ->
      @tag params: %{email: valid_address}
      test "when email is #{valid_address}", %{changeset: changeset} do
        assert changeset.valid?
      end
    end)
  end

  describe "validation / a user already exists" do
    setup :create_user
    setup %{user: user} do
      params = %{
        name: "#{user.name} Jr.",
        email: user.email,
        password: default_password(),
        password_confirmation: default_password()
      }
      [params: params]
    end
    setup [:new_user, :new_changeset]

    test "when email address is already taken", %{changeset: changeset} do
      refute changeset.valid?
    end
  end

  describe "authentication" do
    setup :create_user

    test "when valid passowrd", %{user: user} do
      assert User.authenticated?(user, default_password())
    end

    test "when invalid passowrd", %{user: user} do
      refute User.authenticated?(user, "invalid")
    end
  end
end
