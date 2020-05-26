defmodule SimpleOtp.Vaults do
  import Ecto.Query
  alias SimpleOtp.Repo
  alias SimpleOtp.Vaults.Vault
  alias SimpleOtp.Vaults.Shell

  def list_vaults(user) do
    Vault
    |> where(user_id: ^user.id)
    |> order_by([asc: :inserted_at])
    |> Repo.all()
  end

  def get_vault(id), do: Repo.get(Vault, id)

  def create_vault(user, attrs) do
    %Vault{user_id: user.id}
    |> Vault.changeset(attrs)
    |> Repo.insert()
  end

  def list_shells(vault) do
    Shell
    |> where(vault_id: ^vault.id)
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  def get_shell(id, preload \\ []) do
    Shell
    |> where(id: ^id)
    |> preload(^preload)
    |> Repo.one()
  end

  def search_shell(vault, keyword) do
    keyword = "%#{String.trim(keyword)}%"

    Shell
    |> where([shell], ilike(shell.name, ^keyword))
    |> where(vault_id: ^vault.id)
    |> order_by([:desc, :inserted_at])
    |> Repo.all()
  end

  def create_shell(vault, attrs) do
    %Shell{vault_id: vault.id}
    |> Shell.changeset(attrs)
    |> Repo.insert()
  end
end
