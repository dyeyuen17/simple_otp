defmodule SimpleOtp.Repo.Migrations.CreateTableShells do
  use Ecto.Migration

  def change do
    create table(:shells, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :secret, :string
      add :uri, :string
      add :email, :string
      add :username, :string
      add :description, :text
      add :theme, :string
      add :vault_id, references(:vaults, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:shells, [:vault_id])
    create unique_index(:shells, [:secret])
  end
end
