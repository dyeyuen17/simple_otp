defmodule SimpleOtp.Vaults.Shell do
  use Ecto.Schema
  import Ecto.Changeset

  alias SimpleOtp.Vaults.Vault

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "shells" do
    field :name, :string
    field :secret, :string
    field :uri, :string
    field :recovery_code, :string
    field :description, :string
    field :username, :string
    field :email, :string
    field :theme, :string

    belongs_to :vault, Vault

    timestamps()
  end

  def changeset(shell, attrs) do
    shell
    |> cast(attrs, [:name, :secret, :username, :email, :uri, :recovery_code])
    |> validate_length(:name, max: 30)
    |> validate_secret()
  end

  defp validate_secret(%{valid?: true} = changeset) do
    changeset
    |> validate_format(:secret, ~r/^[a-zA-Z2-8]*$/)
    |> validate_secret_length()
    |> unique_constraint(:secret)
  end

  defp validate_secret(changeset), do: changeset

  defp validate_secret_length(
    %{valid?: true, changes: %{secret: secret}} = changeset
  ) do

    valid_secret? = secret
    |> String.graphemes()
    |> length()
    |> rem(8)
    |> Kernel.==(0)

    if valid_secret? do
      changeset
    else
      add_error(changeset, :secret, "Invalid secret")
    end
  end

  defp validate_secret_length(changeset), do: changeset
end
