defmodule SimpleOtp.Accounts do
  import Ecto.Query, warn: false
  alias SimpleOtp.Repo
  alias SimpleOtp.Accounts.User

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_field(column, value, preload \\ []) do
    User
    |> where([u], field(u, ^column) == ^value)
    |> preload(^preload)
    |> Repo.one()
  end

  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end
end
