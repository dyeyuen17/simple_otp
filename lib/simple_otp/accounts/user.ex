defmodule SimpleOtp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @password_format ~r/^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[0-9])(?=.*[a-z]).{12,}$/
  @username_format ~r/^[a-z0-9]*$/

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :confirm_password, :string, virtual: true
    field :hashed_password, :string

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :confirm_password])
    |> validate_required([:username, :password, :confirm_password])
    |> validate_confirmation(:password)
    |> validate_username()
    |> validate_password()
    |> hash_password()
  end

  defp validate_username(changeset) do
    changeset
    |> validate_length(:username, min: 3)
    |> validate_length(:username, max: 30)
    |> validate_format(:username, @username_format)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 12)
    |> validate_length(:password, max: 70)
    |> validate_format(:password, @password_format)
  end

  defp hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
