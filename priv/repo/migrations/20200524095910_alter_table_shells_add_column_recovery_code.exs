defmodule SimpleOtp.Repo.Migrations.AlterTableShellsAddColumnRecoveryCode do
  use Ecto.Migration

  def change do
    alter table(:shells) do
      add :recovery_code, :string
    end
  end
end
