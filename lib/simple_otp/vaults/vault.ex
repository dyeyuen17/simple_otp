defmodule SimpleOtp.Vaults.Vault do
  use Ecto.Schema
  import Ecto.Changeset

  alias SimpleOtp.Vaults.Shell
  alias SimpleOtp.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "vaults" do
    field :name, :string
    field :type, :string, default: "otp"

    has_many :shells, Shell
    belongs_to :user, User

    timestamps()
  end

  def changeset(vault, attrs) do
    vault
    |> cast(attrs, [:name])
    |> validate_length(:name, max: 30)
    |> unique_constraint(:name)
  end
end
