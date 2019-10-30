defmodule SimpleOtp.Accounts do
  alias SimpleOtp.Repo
  alias SimpleOtp.Accounts.User

  def get_user(id) do
    Repo.get(User, id)
  end
end
