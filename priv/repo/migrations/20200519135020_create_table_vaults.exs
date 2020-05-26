defmodule SimpleOtp.Repo.Migrations.CreateTableVaults do
  use Ecto.Migration

  def change do
    create table(:vaults, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :type, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:vaults, [:user_id])
    create unique_index(:vaults, [:name])
  end
end
